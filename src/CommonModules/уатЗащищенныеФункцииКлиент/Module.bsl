////////////////////////////////////////////////////////////////////////////////
// Управление автотранспортом.
// 
// Защищенные функции клиенсткого контекста.
////////////////////////////////////////////////////////////////////////////////


#Область СлужебныйПрограммныйИнтерфейс

#Область ПроцедурыФункцииОткрытияОбъектов

// Процедура проверки защиты при событии "При открытии" формы списка справочника 
//
Процедура уатСправочникФормаСпискаПриОткрытии(Отказ, ДопПараметры) Экспорт
	
	уатФормаПриОткрытии(Отказ, Неопределено, ДопПараметры);
	
КонецПроцедуры

// Процедура проверки защиты при событии "При открытии" формы элемента справочника
//
Процедура уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметры = Неопределено) Экспорт
	
	уатФормаПриОткрытии(Отказ, Неопределено, ДопПараметры);
	
КонецПроцедуры

// Процедура проверки защиты при событии "При открытии" формы списка документа
//
Процедура уатДокументФормаСпискаПриОткрытии(Отказ, Форма, ДопПараметры = Неопределено) Экспорт
	
	уатФормаПриОткрытии(Отказ, Форма, ДопПараметры);
	
КонецПроцедуры

// Процедура проверки защиты при событии "При открытии" формы элемента документа
//
Процедура уатДокументФормаЭлементаПриОткрытии(Отказ, Форма, ДопПараметры = Неопределено) Экспорт
	
	уатФормаПриОткрытии(Отказ, Форма, ДопПараметры);
	
КонецПроцедуры

// Процедура проверки защиты при событии "При открытии" формы обработки
//
Процедура уатОбработкаФормаПриОткрытии(Отказ, ДопПараметры = Неопределено) Экспорт
	
	уатФормаПриОткрытии(Отказ, Неопределено, ДопПараметры);
	
	// Фиксация замера производительности
	ИмяФормы = Неопределено;
	ДопПараметры.Свойство("ИмяФормы",ИмяФормы);
	Если ИмяФормы <> Неопределено Тогда
		ИмяКлючевойОперации = "ОткрытиеФормы." + уатОбщегоНазначенияКлиентСервер.ОбрезатьИмяФормы(ИмяФормы);
		ОценкаПроизводительностиКлиент.ЗамерВремени(ИмяКлючевойОперации);
	КонецЕсли;	
	
КонецПроцедуры

// Процедура проверки защиты при событии "При открытии" формы списка регистра
//
Процедура уатРегистрФормаСпискаПриОткрытии(Отказ, ДопПараметры = Неопределено) Экспорт
	
	уатФормаПриОткрытии(Отказ, Неопределено, ДопПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыФункцииРаботыСГСМ

// Выбор номенклатуры из регистра сведений НоменклатураГСМ
// Параметры: ГруппаГСМ
// Возвращаемое значение: Справочник-ссылка Номенклатура
Процедура ВыбратьГСМ(ГруппаГСМ = Неопределено, ДополнительныеПараметры = Неопределено, ПроцедураОписаниеОповещения = Неопределено) ЭКСПОРТ
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГСМ", Истина);
	
	Если ЗначениеЗаполнено(ГруппаГСМ) Тогда
		ПараметрыФормы.Вставить("ГруппаГСМ", ГруппаГСМ);
	Иначе
		ПараметрыФормы.Вставить("ГруппаГСМ", ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"));
	КонецЕсли;
	
	КлючУникальности = Неопределено;
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		Если ДополнительныеПараметры.Свойство("ЗначениеГСМДоИзменения") Тогда
			ПараметрыФормы.Вставить("НачальноеЗначениеВыбора", ДополнительныеПараметры.ЗначениеГСМДоИзменения);
		ИначеЕсли ДополнительныеПараметры.Свойство("НачальноеЗначениеВыбора") Тогда
			ПараметрыФормы.Вставить("НачальноеЗначениеВыбора", ДополнительныеПараметры.НачальноеЗначениеВыбора);
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("УчитыватьТЖ") И ДополнительныеПараметры.УчитыватьТЖ Тогда
			ПараметрыФормы.Вставить("УчитыватьТЖ", ДополнительныеПараметры.УчитыватьТЖ);
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("КлючУникальности") Тогда
			КлючУникальности = ДополнительныеПараметры.КлючУникальности;
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("Отбор") Тогда 
			ПараметрыФормы.Вставить("Отбор", ДополнительныеПараметры.Отбор);
		КонецЕсли;
	КонецЕсли;
		
	ОткрытьФорму("РегистрСведений.уатНоменклатураГСМ.ФормаСписка", ПараметрыФормы,,КлючУникальности,,, ПроцедураОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры // уатВыбратьГСМ 

// Возвращает форму списка ГСМ
Процедура СписокГСМдляТС(Организация, ТС, ГруппаГСМ, БезАналогов = Ложь, УчитыватьТЖ = Ложь, ПроцедураОписаниеОповещения = Неопределено) ЭКСПОРТ
	ПараметрыФормы = Новый Структура("ГруппаГСМ, ТС, Организация, БезАналогов, УчитыватьТЖ", ГруппаГСМ, ТС, Организация, БезАналогов, УчитыватьТЖ);
	ОткрытьФорму("ОбщаяФорма.уатСписокГСМ", ПараметрыФормы,,,,, ПроцедураОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры // уатСписокГСМдляТС

#КонецОбласти

#Область ПроцедурыФункцииРаботыСГрузами

// Выбор номенклатуры из регистра сведений НоменклатураГСМ
// Параметры: ГруппаГСМ
// Возвращаемое значение: Справочник-ссылка Номенклатура
Процедура ДиалогВыбораГруза(Элемент, Номенклатура, ВладелецФормы, СтандартнаяОбработка, ДопПараметры = Неопределено) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("РежимВыбора, НачальноеЗначениеВыбора", Истина, Номенклатура);
	// установим необходимые отборы
	Если ТипЗнч(ДопПараметры) = Тип("Структура") И ДопПараметры.Свойство("ПараметрыОтбора") Тогда
		ПараметрыФормы.Вставить("Отбор", ДопПараметры.ПараметрыОтбора);
	КонецЕсли;
	ОткрытьФорму("РегистрСведений.уатНоменклатураГрузов.Форма.ФормаВыбора", ПараметрыФормы, ВладелецФормы);
КонецПроцедуры // уатДиалогВыбораГруза       

#КонецОбласти

#Область ПроцедурыФункцииРаботыССотрудниками

// Выбор сотрудника/водителя из спр. Сотрудники с помощью форм обработки уатСотрудники
// Параметры:
//	- Элемент, связанный с сотрудником
//	- ТекСотрудник, ссылка на данные сотрудника
//	- ПараметрыОтбора, структура отбора
//	- СтандартнаяОбработка, переданный параметр обработчика НачалоВыбора
//
Процедура ДиалогВыбораСотрудника(Элемент, ТекСотрудник, ПараметрыОтбора, СтандартнаяОбработка) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("РежимВыбора, НачальноеЗначениеВыбора", Истина, ТекСотрудник);
	// установим необходимые отборы
	Если ТипЗнч(ПараметрыОтбора) = Тип("Структура") Тогда
		ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	КонецЕсли;
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаСписка", ПараметрыФормы, Элемент);
КонецПроцедуры

// Открытие формы элемента сотрудника/водителя из спр. Сотрудники с помощью формы обработки уатСотрудники
// Параметры:
//	- ТекСотрудник, ссылка на данные сотрудника
//	- СтандартнаяОбработка, переданный параметр обработчика НачалоВыбора
//
Процедура ОткрытьФормуСотрудника(ТекСотрудник, СтандартнаяОбработка) ЭКСПОРТ
	Если НЕ ЗначениеЗаполнено(ТекСотрудник) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("Ключ", ТекСотрудник);
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаЭлемента", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область Проверка_ИТС_Отраслевой

Функция ИТСОтраслевой_ПроверкаДоступностиСервисов() Экспорт
	флОК = уатЗащищенныеФункцииСервер.ЕстьПодпискаИТСОтраслевой();
	Если НЕ флОК Тогда
		ОткрытьФорму("ОбщаяФорма.уатПодпискаИТСОтраслевой");
	КонецЕсли;
	
	Возврат флОК;
КонецФункции

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Общая процедура проверки защиты при событии "При открытии" всех форм
//
// Параметры:
//  Отказ		 - 	 - 
//  Форма		 - 	 - 
//  ДопПараметры - 	 - 
//
Процедура уатФормаПриОткрытии(Отказ, Форма, ДопПараметры)
	
	Если ДопПараметры = Неопределено Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	уатОбщегоНазначенияКлиент.уатИнициализацияСеансаКлиент(ДопПараметры);
	
	Если ТипЗнч(ДопПараметры) = Тип("Структура") И ДопПараметры.Свойство("Отказ") И ДопПараметры.Отказ Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Не Форма = Неопределено Тогда
		ФормаЭлементЗаписать = Форма.Элементы.Найти("ФормаЗаписать");
		Если Не ФормаЭлементЗаписать = Неопределено Тогда 
			ФормаЭлементЗаписать.Отображение = ОтображениеКнопки.Картинка;
		КонецЕсли;
		
		ФормаЭлементПровести = Форма.Элементы.Найти("ФормаПровести");
		Если Не ФормаЭлементПровести = Неопределено Тогда 
			ФормаЭлементПровести.Отображение = ОтображениеКнопки.Картинка;
		КонецЕсли;
		
		ФормаЭлементСоздатьНаОсновании = Форма.Элементы.Найти("ФормаСоздатьНаОсновании");
		Если Не ФормаЭлементСоздатьНаОсновании = Неопределено Тогда 
			ФормаЭлементСоздатьНаОсновании.Отображение = ОтображениеКнопки.Картинка;
			ФормаЭлементСоздатьНаОсновании.Картинка = БиблиотекаКартинок.уатПодменюВводаНаОсновании;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
