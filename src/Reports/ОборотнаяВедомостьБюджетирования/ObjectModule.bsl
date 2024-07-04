#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ВнешниеНаборы = НаборыДанных();
	
	БюджетированиеСервер.ДополнитьСхемуКомпоновкиДанныхАналитикойПоВиду(СхемаКомпоновкиДанных, "СтатьяБюджетов");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборы, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки(); 
	СценарииОтчета = Справочники.Сценарии.СценарииСУчетомОтбора(НастройкиОтчета);
	
	НеобходимПересчетСуммыВВалютуОтчета = Ложь;
	ВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта").Значение;
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение;
	Если ВалютаОтчета <> Константы.ВалютаРегламентированногоУчета.Получить() 
		И ВалютаОтчета <> Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		НеобходимПересчетСуммыВВалютуОтчета = Истина;
	КонецЕсли;
	
	Если НеобходимПересчетСуммыВВалютуОтчета Тогда
		
		СценарииДляПроверки = СценарииОтчета.НайтиСтроки(Новый Структура("ТребоватьУказанияКурсовДляКаждогоПериода", Истина));
		Сценарии = Новый Массив;
		Для каждого СтрокаСценарий Из СценарииДляПроверки Цикл
			Сценарии.Добавить(СтрокаСценарий.Сценарий); 
		КонецЦикла;
		
		Валюты = Новый Массив;
		Валюты.Добавить(ВалютаОтчета);
		
		НезаполненныеКурсыСценариев = Справочники.Сценарии.ПроверитьЗаполнениеКурсовСценариев(Сценарии, Валюты, Период.ДатаНачала, Период.ДатаОкончания);
		Если НезаполненныеКурсыСценариев.Количество() > 0 Тогда
			ШаблонСообщения = НСтр("en='Необходимо указать прогнозный курс валюты %1 сценария %2 на %3';ru='Необходимо указать прогнозный курс валюты %1 сценария %2 на %3'");
			Для каждого Строка Из НезаполненныеКурсыСценариев Цикл
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения, 
					Строка.Валюта, 
					Строка.Сценарий, 
					Формат(Строка.Период, "ДЛФ=Д"));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолучениеДанныхОтчета

Функция НаборыДанных()
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ПараметрыПолученияФакта = ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета);
	
	НаборыДанных = Новый Структура;
	НаборыДанных.Вставить("ОборотыПлан", ОборотыПлан(НастройкиОтчета));
	НаборыДанных.Вставить("ОборотыФакт", ОборотыФакт(НастройкиОтчета, ПараметрыПолученияФакта));
	
	Возврат НаборыДанных; 
	
КонецФункции

Функция ОборотыПлан(НастройкиОтчета) 
	
	СхемаКомпоновкиПлана = Отчеты.ОборотнаяВедомостьБюджетирования.ПолучитьМакет("ОборотыПлан");
	Настройки = СхемаКомпоновкиПлана.НастройкиПоУмолчанию;
	
	БюджетированиеСервер.ДополнитьСхемуКомпоновкиДанныхАналитикойПоВиду(СхемаКомпоновкиПлана, "СтатьяБюджетов");
	
	КомпоновкаДанныхКлиентСервер.ЗаполнитьЭлементы(Настройки.ПараметрыДанных, НастройкиОтчета.ПараметрыДанных);
	КомпоновкаДанныхКлиентСервер.СкопироватьОтборКомпоновкиДанных(СхемаКомпоновкиПлана, Настройки, НастройкиОтчета);
	
	Группировка = Настройки.Структура[0];
	
	Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "Регистратор") Тогда
		ФинансоваяОтчетностьСервер.НовоеПолеГруппировки(Группировка, "Регистратор");
	КонецЕсли;
	
	Для каждого Периодичность Из Перечисления.Периодичность.УпорядоченныеПериодичности() Цикл
		ПолеПериод = "Период" + Строка(Периодичность);
		Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, ПолеПериод) Тогда
			ФинансоваяОтчетностьСервер.НовоеПолеГруппировки(Группировка, ПолеПериод);
		КонецЕсли;
	КонецЦикла;
	
	НеобходимПересчетСуммыВВалютуОтчета = Ложь;
	ВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта").Значение;
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение; 
	
	Если уатОбщегоНазначенияТиповые.уатЕстьКонстанта("ВалютаУправленческогоУчета") Тогда
		ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	Иначе
		ВалютаУправленческогоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;
	
	Если ВалютаОтчета = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		ВыражениеСуммы = "СуммаРегл";
	ИначеЕсли ВалютаОтчета = ВалютаУправленческогоУчета Тогда
		ВыражениеСуммы = "СуммаУпр";
	Иначе
		ВыражениеСуммы = "ВЫБОР КОГДА Валюта = &Валюта ТОГДА СуммаВВалюте ИНАЧЕ СуммаРегл / ЕСТЬNULL(Курс,1) КОНЕЦ";
		НеобходимПересчетСуммыВВалютуОтчета = Истина;
	КонецЕсли;
	
	Ресурсы = Новый Структура;
	Ресурсы.Вставить("СуммаПлан", ВыражениеСуммы);
	Ресурсы.Вставить("КоличествоПлан", "Количество");
	Для каждого Ресурс Из Ресурсы Цикл
		ФинансоваяОтчетностьСервер.НовыйВычисляемыйРесурс(СхемаКомпоновкиПлана, Ресурс.Ключ, Ресурс.Значение, "Сумма");
		ФинансоваяОтчетностьСервер.НовоеПолеВыбора(Настройки, Ресурс.Ключ);
	КонецЦикла;
	
	План = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СхемаКомпоновкиПлана, Настройки);
	
	Возврат План;
	
КонецФункции

Функция ОборотыФакт(НастройкиОтчета, ПараметрыПолученияФакта)
	
	ФактПоСтатьямБюджетов = БюджетированиеСервер.ФактПоСтатьямБюджетов(НастройкиОтчета, ПараметрыПолученияФакта);
	
	Если ЗначениеЗаполнено(ПараметрыПолученияФакта.Периодичность) Тогда
		ФактПоСтатьямБюджетов.Колонки["Период"].Имя = "Период" + ПараметрыПолученияФакта.Периодичность;
	КонецЕсли;
	
	НаборДанныхФакт = СхемаКомпоновкиДанных.НаборыДанных.ОборотыФакт;
	Для каждого ПолеНабораДанных Из НаборДанныхФакт.Поля Цикл
		Если ФактПоСтатьямБюджетов.Колонки.Найти(ПолеНабораДанных.Поле) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ФактПоСтатьямБюджетов.Колонки.Добавить(ПолеНабораДанных.Поле, ПолеНабораДанных.ТипЗначения);
	КонецЦикла;
	
	ФактПоСтатьямБюджетов.Колонки.Добавить("Сценарий", Новый ОписаниеТипов("СправочникСсылка.Сценарии"));
	ФактПоСтатьямБюджетов.ЗаполнитьЗначения(Справочники.Сценарии.ФактическиеДанные, "Сценарий");
	
	Возврат ФактПоСтатьямБюджетов;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета)
	
	Параметры = БюджетированиеСервер.ПараметрыПолученияФакта();
	
	Параметры.ВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта").Значение;
	Параметры.Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение; 
	
	Параметры.ПоОрганизациям = Истина;
	Параметры.ПоПодразделениям = Истина;
	
	Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "Регистратор") Тогда
		Параметры.РазворачиватьПоРегистратору = Истина;
	КонецЕсли;
	
	Периодичности = Новый Массив;
	Для каждого Периодичность Из Перечисления.Периодичность.УпорядоченныеПериодичности() Цикл
		Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "Период" + Строка(Периодичность)) Тогда
			Периодичности.Добавить(Периодичность);
		КонецЕсли;
	КонецЦикла;
	Параметры.Периодичность = Перечисления.Периодичность.МинимальнаяПериодичность(Периодичности);
	
	Возврат Параметры; 
	
КонецФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	ПараметрВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");
	Если ПараметрВалюта <> Неопределено И Не ЗначениеЗаполнено(ПараметрВалюта.Значение) Тогда
		Если уатОбщегоНазначенияТиповые.уатЕстьКонстанта("ВалютаУправленческогоУчета") Тогда
			ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
		Иначе
			ВалютаУправленческогоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		КонецЕсли;
		
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, "Валюта", ВалютаУправленческогоУчета);
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#КонецЕсли