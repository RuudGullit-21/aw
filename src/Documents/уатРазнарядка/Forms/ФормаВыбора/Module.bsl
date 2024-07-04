
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ДатаНачала") И Параметры.Свойство("ДатаОкончания") Тогда
		ДатаНачала    = Параметры.ДатаНачала;
		ДатаОкончания = Параметры.ДатаОкончания;
		флУстановитьОтбор = Истина;
		
		ГруппаОтбора = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		
		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		ЭлементОтбора.ПравоеЗначение   = ДатаНачала;
		ЭлементОтбора.ИдентификаторПользовательскойНастройки = "ДатаНачала";
		
		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		ЭлементОтбора.ПравоеЗначение   = ДатаОкончания;
		ЭлементОтбора.ИдентификаторПользовательскойНастройки = "ДатаОкончания";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатДокументФормаСпискаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементОтбора = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти("ДатаНачала");
	Если ЭлементОтбора <> Неопределено И флУстановитьОтбор Тогда
		//ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		ЭлементОтбора.ПравоеЗначение   = ДатаНачала;
	ИначеЕсли ЭлементОтбора <> Неопределено Тогда
		Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Удалить(ЭлементОтбора);
	КонецЕсли;
	ЭлементОтбора = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти("ДатаОкончания");
	Если ЭлементОтбора <> Неопределено И флУстановитьОтбор Тогда
		//ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		ЭлементОтбора.ПравоеЗначение   = ДатаОкончания;
	ИначеЕсли ЭлементОтбора <> Неопределено Тогда
		Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Удалить(ЭлементОтбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьДокументы(Команда)
	ТекДок = Элементы.Список.ТекущиеДанные;
	Если ТекДок <> Неопределено Тогда
		уатОбщегоНазначенияКлиент.ОткрытьОтчетПоДокументамТСиВодителей(ТекДок.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
