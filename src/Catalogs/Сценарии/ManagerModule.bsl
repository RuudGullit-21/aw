#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
//  
//  Возвращаемое значание:
//  Массив - имена блокируемых реквизитов
// 
// Возвращаемое значение:
//   - 
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Периодичность");
	Результат.Добавить("Валюта");
	
	Возврат Результат;
	
КонецФункции

// Возвращает наименьшую из переданной периодичности и периодичностей сценариев
//
// Параметры:
//  Сценарии		 - 								 - 
//  Периодичность	 - ПеречислениеСсылка.Периодичность	 - периодичность, с которой требуется сравнить
//  	периодичность сценариев
//  	Возвращаемое значание:
//  	ПеречислениеСсылка.Периодичность - вычисленная периодичность
// 
// Возвращаемое значение:
//   - 
//
Функция ПривестиПериодичностьКПериодичностиСценария(Сценарии, Периодичность) Экспорт
	
	ПериодичностиСценариев = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сценарии, "Периодичность");
	ПериодичностиПоПорядку = Перечисления.Периодичность.УпорядоченныеПериодичности();
	
	ПериодичностьСценариев       = Перечисления.Периодичность.ПустаяСсылка();
	ИндексПериодичностиСценариев = 0;
	Для каждого Элемент Из ПериодичностиСценариев Цикл
		Индекс = ПериодичностиПоПорядку.Найти(Элемент.Значение);
		Если Индекс > ИндексПериодичностиСценариев Тогда
			ИндексПериодичностиСценариев = Индекс;
			ПериодичностьСценариев       = Элемент.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(Периодичность) Тогда
		Периодичность = ПериодичностьСценариев;
	ИначеЕсли ИндексПериодичностиСценариев > ПериодичностиПоПорядку.Найти(Периодичность) Тогда 
		Периодичность = ПериодичностьСценариев;
	КонецЕсли;

	Возврат Периодичность;
	
КонецФункции

// Возвращает таблицу прогнозных курсов сценариев за выбранный период,
//  дополненную начальными курсами
//
// Параметры:
//  Сценарий		 - Массив	 - СправочникСсылка.Сценарии, сценарии, для которых
//  	требуется получить курсы
//  Валюты			 - Массив	 - Валюты, по которым требуется получить таблицу курсов.
//  	если не указано - то по всем
//  ДатаНачала		 - Дата		 - дата начала курсов
//  ДатаОкончания	 - Дата		 - дата окончания курсов
//  		Возвращаемое значание:
//  		ТаблицаЗначений - таблица курсов
// 
// Возвращаемое значение:
//   - 
//
Функция ТаблицаКурсовСценария(Сценарий = Неопределено, Валюты = Неопределено, ДатаНачала, ДатаОкончания) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	флЕС = Константы.уатКонфигурацияДляЕС.Получить();
	УстановитьПривилегированныйРежим(Ложь);
		
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Сценарии.Ссылка КАК Сценарий,
	|	Сценарии.Ссылка КАК СценарийКурсов
	|ПОМЕСТИТЬ ФильтрПоСценариям
	|ИЗ
	|	Справочник.Сценарии КАК Сценарии
	|ГДЕ
	|	(&СценарийНеопределен ИЛИ Сценарии.Ссылка В (&Сценарий))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&НачалоПериода КАК Период,
	|	ПрогнозныеКурсыСценариев.Валюта КАК Валюта,
	|	ФильтрПоСценариям.Сценарий КАК Сценарий,
	|	ВЫБОР
	|		КОГДА &флЕС
	|			ТОГДА ВЫБОР
	|					КОГДА ПрогнозныеКурсыСценариев.Курс = 0
	|						ТОГДА 0
	|					ИНАЧЕ ПрогнозныеКурсыСценариев.Кратность / ПрогнозныеКурсыСценариев.Курс
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ПрогнозныеКурсыСценариев.Кратность = 0
	|					ТОГДА 0
	|				ИНАЧЕ ПрогнозныеКурсыСценариев.Курс / ПрогнозныеКурсыСценариев.Кратность
	|			КОНЕЦ
	|	КОНЕЦ КАК Курс
	|ИЗ
	|	РегистрСведений.ПрогнозныеКурсыСценариев.СрезПоследних(
	|			&НачалоПериода,
	|			Сценарий В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						Фильтр.СценарийКурсов
	|					ИЗ
	|						ФильтрПоСценариям КАК Фильтр)
	|				И (&ВалютаНеопределена
	|					ИЛИ Валюта В (&Валюты))) КАК ПрогнозныеКурсыСценариев
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ФильтрПоСценариям КАК ФильтрПоСценариям
	|		ПО ПрогнозныеКурсыСценариев.Сценарий = ФильтрПоСценариям.СценарийКурсов
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПрогнозныеКурсыСценариев.Период,
	|	ПрогнозныеКурсыСценариев.Валюта,
	|	ФильтрПоСценариям.Сценарий,
	|	ВЫБОР
	|		КОГДА &флЕС
	|			ТОГДА ВЫБОР
	|					КОГДА ПрогнозныеКурсыСценариев.Курс = 0
	|						ТОГДА 0
	|					ИНАЧЕ ПрогнозныеКурсыСценариев.Кратность / ПрогнозныеКурсыСценариев.Курс
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ПрогнозныеКурсыСценариев.Кратность = 0
	|					ТОГДА 0
	|				ИНАЧЕ ПрогнозныеКурсыСценариев.Курс / ПрогнозныеКурсыСценариев.Кратность
	|			КОНЕЦ
	|	КОНЕЦ
	|ИЗ
	|	ФильтрПоСценариям КАК ФильтрПоСценариям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПрогнозныеКурсыСценариев КАК ПрогнозныеКурсыСценариев
	|		ПО (ПрогнозныеКурсыСценариев.Период МЕЖДУ &НачалоПериода И &КонецПериода)
	|			И (ПрогнозныеКурсыСценариев.Сценарий = ФильтрПоСценариям.СценарийКурсов)
	|			И (&ВалютаНеопределена
	|				ИЛИ ПрогнозныеКурсыСценариев.Валюта В (&Валюты))");
	
	Запрос.УстановитьПараметр("Валюты", Валюты);
	Запрос.УстановитьПараметр("ВалютаНеопределена", Валюты = Неопределено);
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("СценарийНеопределен", Сценарий = Неопределено);
	Запрос.УстановитьПараметр("НачалоПериода", ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ДатаОкончания);
	Запрос.УстановитьПараметр("флЕС", флЕС);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает таблицу, содержащую информацию о незаполненных курсах сценариев.
//
// Параметры:
//  Сценарии		 - 	 - 
//  Валюты			 - Массив	 - Валюты, по которым необходимо выполнить проверку заполнения курсов
//  ДатаНачала		 - Дата		 - Начало периода проверки
//  ДатаОкончания	 - Дата		 - Окончание периода проверки
//  		Возвращаемое значание:
//  		ТаблицаЗначений - таблица незаполненных курсов
// 
// Возвращаемое значение:
//   - 
//
Функция ПроверитьЗаполнениеКурсовСценариев(Сценарии, Валюты, ДатаНачала, ДатаОкончания) Экспорт
	
	ПериодичностиСценариев = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сценарии, "Периодичность");
	КурсыСценариев = Справочники.Сценарии.ТаблицаКурсовСценария(Сценарии, Валюты, ДатаНачала, ДатаОкончания);
	КурсыСценариев.Индексы.Добавить("Сценарий, Валюта, Период");
	
	НезаполненныеКурсы = КурсыСценариев.СкопироватьКолонки("Сценарий, Валюта, Период");
	
	Для каждого Сценарий Из Сценарии Цикл
		Периоды = БюджетнаяОтчетностьСервер.ПолучитьМассивПериодов(ДатаНачала, ДатаОкончания, ПериодичностиСценариев[Сценарий]);
		Для каждого Период Из Периоды Цикл
			Для каждого Валюта Из Валюты Цикл
				СтруктураПоиска = Новый Структура("Сценарий, Валюта, Период", Сценарий, Валюта, Период);
				Если КурсыСценариев.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
					НоваяСтрока = НезаполненныеКурсы.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПоиска);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат НезаполненныеКурсы;
	
КонецФункции

// Возвращает таблицу сценариев с учетом отбора компоновки данных
//
// Параметры:
//  ОтборКомпоновкиДанны - НастройкиКомпоновкиДанных - Настройки отбора по сценарию
// 
// Возвращаемое значение:
//   - 
//
Функция СценарииСУчетомОтбора(ОтборКомпоновкиДанны) Экспорт
	
	СхемаКомпоновкиДанных = ФинансоваяОтчетностьСервер.НоваяСхема();
	НаборДанныхСценарии = ФинансоваяОтчетностьСервер.НовыйНабор(
		СхемаКомпоновкиДанных, Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"), "Сценарии");
		
	НаборДанныхСценарии.Запрос = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Сценарии.Ссылка КАК Сценарий,
	|	Сценарии.Валюта КАК Валюта,
	|	Сценарии.ТребоватьУказанияКурсовДляКаждогоПериода КАК ТребоватьУказанияКурсовДляКаждогоПериода
	|ИЗ
	|	Справочник.Сценарии КАК Сценарии
	|ГДЕ
	|	НЕ Сценарии.ЭтоГруппа
	|	И НЕ Сценарии.ПометкаУдаления";
	НаборДанныхСценарии.АвтоЗаполнениеДоступныхПолей = Истина;
	
	Настройки = Новый НастройкиКомпоновкиДанных;
	КомпоновкаДанныхКлиентСервер.ДобавитьГруппировку(Настройки);
	КомпоновкаДанныхКлиентСервер.ДобавитьВыбранноеПоле(Настройки, "Сценарий");
	КомпоновкаДанныхКлиентСервер.ДобавитьВыбранноеПоле(Настройки, "Валюта");
	КомпоновкаДанныхКлиентСервер.ДобавитьВыбранноеПоле(Настройки, "Периодичность");
	КомпоновкаДанныхКлиентСервер.ДобавитьВыбранноеПоле(Настройки, "ТребоватьУказанияКурсовДляКаждогоПериода");
	КомпоновкаДанныхКлиентСервер.СкопироватьОтборКомпоновкиДанных(СхемаКомпоновкиДанных, Настройки, ОтборКомпоновкиДанны);
	
	Возврат ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СхемаКомпоновкиДанных, Настройки);
	
КонецФункции

#КонецОбласти

#КонецЕсли