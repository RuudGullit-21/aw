
#Область СлужебныеПроцедурыИФункции

// Функция добавляет операнды в таблицу операндов
//
// Параметры:
//  Форма  - УправляемаяФорма - Форма конструктора формул
//  НовыеОперанды  - Массив - Строки дерева операндов
//  ТаблицаОперандов - ТаблицаЗначений - Таблица выбранных в формуле операндов
//  Уникальный - Булево - признак уникальности операндов (добавлять операнды если есть)
//
// Возвращаемое значение:
//   Массив   - массив добавленных строк таблицы операндов
//
Функция ДобавитьОперандыФормулы(Форма, НовыеОперанды, ТаблицаОперандов, Уникальный) Экспорт
	
	МассивДобавленных = Новый Массив;
	Для Каждого Операнд Из НовыеОперанды Цикл
		
		Если Операнд.ЭтоГруппа = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		Идентификатор = ИмяОперанда(Операнд.Наименование, ТаблицаОперандов, Уникальный);
		
		НайденныйОперанд = Неопределено;
		Если ЕстьПоказатель(Идентификатор, ТаблицаОперандов, НайденныйОперанд) Тогда
			МассивДобавленных.Добавить(НайденныйОперанд);
		Иначе
			НоваяСтрока = ТаблицаОперандов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Операнд);
			НоваяСтрока.Идентификатор = Идентификатор;
			НоваяСтрока.НаименованиеДляПечати = Операнд.Наименование;
			НоваяСтрока.СтатьяПоказательТипИзмерения = Операнд.ЭлементВидаОтчетности;
			
			НоваяСтрока.ВыводимыеПоказатели = ПредопределенноеЗначение("Перечисление.ТипыВыводимыхПоказателейБюджетногоОтчета.Сумма");
			Если НоваяСтрока.ВидЭлемента = ПредопределенноеЗначение("Перечисление.ВидыЭлементовФинансовогоОтчета.ПоказательБюджетов") Тогда
				НоваяСтрока.ТипЗначенияПоказателя = ПредопределенноеЗначение("Перечисление.ТипыЗначенийПоказателейБюджетногоОтчета.Оборот");
			КонецЕсли;
			
			МассивДобавленных.Добавить(НоваяСтрока);
		КонецЕсли;
		
		Если НЕ Форма.Модифицированность Тогда
			Форма.Модифицированность = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивДобавленных;
	
КонецФункции

// Процедура устанавливает период смещения в формах статей бюджетов, показателей бюджетов
// так же корректирует наименование для отображения установленного смещения
//
// Параметры:
//  Объект  - СправочникОбъект.ЭлементыФинансовыхОтчетов - объект формы
//  Форма  - УправляемаяФорма - форма, для которой устанавливаем смещение
//  РезультатВыбора  - Структура - результат выбора в форме настройки смещения
//
Процедура УстановитьПериодСмещения(Объект, Форма, РезультатВыбора) Экспорт
	
	Перем ЗначениеПустое;
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущееПредставлениеСмещения = БюджетнаяОтчетностьКлиентСервер.ПредставлениеСмещения(Форма);
	
	ЗаполнитьЗначенияСвойств(Форма, РезультатВыбора);
	
	НовоеПредставлениеСмещения = БюджетнаяОтчетностьКлиентСервер.ПредставлениеСмещения(Форма, ЗначениеПустое);
	Форма.Элементы.НастройкаСмещенияПериода.Заголовок = НовоеПредставлениеСмещения;
	
	Если Найти(Объект.НаименованиеДляПечати, ПредыдущееПредставлениеСмещения) Тогда
		Если ЗначениеПустое Тогда
			Объект.НаименованиеДляПечати = СтрЗаменить(Объект.НаименованиеДляПечати, "(" + ПредыдущееПредставлениеСмещения + ")", "");
		Иначе
			Объект.НаименованиеДляПечати = СтрЗаменить(Объект.НаименованиеДляПечати, ПредыдущееПредставлениеСмещения, НовоеПредставлениеСмещения);
		КонецЕсли;
	ИначеЕсли Не ЗначениеПустое Тогда
		Постфикс = " (" + НовоеПредставлениеСмещения + ")";
		Если Не Прав(Объект.НаименованиеДляПечати, СтрДлина(Постфикс)) = Постфикс Тогда
			Объект.НаименованиеДляПечати = Объект.НаименованиеДляПечати + Постфикс;
		КонецЕсли;
	КонецЕсли;
	Объект.НаименованиеДляПечати = СокрЛП(Объект.НаименованиеДляПечати);
	
КонецПроцедуры

Функция ЕстьПоказатель(Идентификатор, ТаблицаОперандов, НайденныйОперанд = Неопределено)
	
	Для Каждого СтрокаОперанда из ТаблицаОперандов Цикл
		Если СтрокаОперанда.Идентификатор = Идентификатор Тогда
			НайденныйОперанд = СтрокаОперанда;
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ИмяОперанда(Наименование, ТаблицаОперандов, Уникальный)
	
	Массив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Наименование, " ", Истина);
	Результат = "";
	Для Каждого Элемент из Массив Цикл
		Результат = Результат + ТРег(СокрЛП(Лев(Элемент, 7)));
	КонецЦикла;
	
	Идентификатор = Результат;
	Если Не Уникальный Тогда
		Возврат Идентификатор;
	КонецЕсли;
	
	Сч = 0;
	Пока ЕстьПоказатель(Идентификатор, ТаблицаОперандов) Цикл
		Сч = Сч + 1;
		Идентификатор = Результат + "_" + Формат(Сч, "ЧГ=");
	КонецЦикла;
	
	Возврат Идентификатор;
	
КонецФункции

Процедура ОткрытьФормуОтчета(ПараметрыОткрытия, ФормаВладелец) Экспорт
	Перем ХранимыеПараметрыОтчета;
	
	ДополнительныйИндексУникальности = 0;
	Если ПараметрыОткрытия.ПараметрыОтчета.Свойство("ХранимыеПараметрыОтчета", ХранимыеПараметрыОтчета) Тогда
		ДополнительныйИндексУникальности = ХранимыеПараметрыОтчета.ИндексСтрокиДанных;
	КонецЕсли;
	
	КлючУникальности = Строка(ФормаВладелец.УникальныйИдентификатор) + "_" + ДополнительныйИндексУникальности;
	
	Форма = ПолучитьФорму(ПараметрыОткрытия.ИмяФормы, ПараметрыОткрытия.ПараметрыОтчета, ФормаВладелец, КлючУникальности);
	Если Форма.Открыта() Тогда
		Форма.Закрыть();
		Форма = Неопределено;
		ОткрытьФорму(ПараметрыОткрытия.ИмяФормы, ПараметрыОткрытия.ПараметрыОтчета, ФормаВладелец, КлючУникальности);
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

