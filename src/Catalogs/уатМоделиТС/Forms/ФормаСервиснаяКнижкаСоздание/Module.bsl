#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПланированиеТО    = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ПоВыработке");
	ПараметрВыработки = Справочники.уатПараметрыВыработки.ПробегОбщий;
	СервисныйИнтервал = 20000;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВидимостьЭлементов();
	ПараметрВыработкиПриИзменении(Элементы.ПараметрВыработки);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПараметрВыработкиПриИзменении(Элемент)
	
	ЕдиницаИзмерения = ПолучитьЕдиницуИзмерения();
	ЕдиницаИзмеренияСтрока = ?(ЗначениеЗаполнено(ЕдиницаИзмерения)," (" + ЕдиницаИзмерения + ")","");
	
	Элементы.СервисныйИнтервал.Заголовок = НСтр("en='Parameter value';ru='Сервисный интервал'") + ЕдиницаИзмеренияСтрока;
	Элементы.ДопускПараметрВыработки.Заголовок = НСтр("en='Access';ru='Допуск'") + ЕдиницаИзмеренияСтрока;
	Элементы.ЧтоНаступитРаньше_ЗначениеПараметраВыработки.Заголовок = НСтр("en='Parameter value';ru='Сервисный интервал'") + ЕдиницаИзмеренияСтрока;
	Элементы.ЧтоНаступитРаньше_ДопускПараметрВыработки.Заголовок = НСтр("en='Access';ru='Допуск'") + ЕдиницаИзмеренияСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура ПланированиеТОПриИзменении(Элемент)
	
	Если ПланированиеТО = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ПоВремени") Тогда
		КоличествоПериодов = 1;  
	Иначе
		КоличествоПериодов = Неопределено;
	КонецЕсли;
	ВидимостьЭлементов();
	
	ПериодичностьОбслуживания  = Неопределено;
	ПараметрВыработки          = Неопределено;
	СервисныйИнтервал          = Неопределено;
	Допуск                     = Неопределено;
	ДопускПерОбслуживания      = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)

	ЗначенияЗаполнения = Новый Структура();
	ЗначенияЗаполнения.Вставить("ПериодичностьОбслуживания",  ПериодичностьОбслуживания);
	ЗначенияЗаполнения.Вставить("КоличествоПериодов",         КоличествоПериодов);
	ЗначенияЗаполнения.Вставить("ПараметрВыработки",          ПараметрВыработки);
	ЗначенияЗаполнения.Вставить("СервисныйИнтервал",          СервисныйИнтервал);
	ЗначенияЗаполнения.Вставить("ПланированиеТО",             ПланированиеТО);
	ЗначенияЗаполнения.Вставить("Допуск",                     Допуск);
	ЗначенияЗаполнения.Вставить("ДопускПерОбслуживания",      ДопускПерОбслуживания);
	
	Закрыть(ЗначенияЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьЕдиницуИзмерения()
	
	Возврат ПараметрВыработки.ЕдиницаИзмерения; 
	
КонецФункции

&НаКлиенте
Процедура ВидимостьЭлементов()
	
	Если ПланированиеТО = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ПоВремени") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоВремени;
		Если КоличествоПериодов = 0 Тогда
			КоличествоПериодов = 1;
		КонецЕсли;
	ИначеЕсли ПланированиеТО = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ПоВыработке") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоВыработке;
	ИначеЕсли ПланированиеТО = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ЧтоНаступитРаньше") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаЧтоНаступитРаньше;
		Если КоличествоПериодов = 0 Тогда
			КоличествоПериодов = 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти