
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПрочитатьАдресСклада();
	Элементы.ГруппаАдресноеХранение.Видимость = ПолучитьФункциональнуюОпцию("уатАдресноеХранение") = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьАдресСклада();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновлениеМестРемонтов", Объект.Ссылка, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресноеХранениеПриИзменении(Элемент)
	Если Объект.АдресноеХранение И Объект.Ссылка.Пустая() Тогда
		Оповещ = Новый ОписаниеОповещения("АдресноеХранениеПриИзмененииВопрос", ЭтотОбъект);
		ПоказатьВопрос(Оповещ, "Перед установкой адресного хранения нужно записать элемент. Продолжить?",
			РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
		
	Если НЕ Объект.АдресноеХранение Тогда
		Объект.ТранзитнаяЯчейка = Неопределено;
		Объект.РазделительНаименованияЯчеек = "";
	КонецЕсли;
	
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура АдресноеХранениеПриИзмененииВопрос(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Объект.АдресноеХранение = Ложь;
		Если ПроверитьЗаполнение() Тогда
			Записать();
			Объект.АдресноеХранение = Истина;
			Модифицированность = Истина;
			УстановитьВидимость();
		Иначе
			Объект.АдресноеХранение = Ложь;
		КонецЕсли;
	Иначе
		Объект.АдресноеХранение = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПрочитатьАдресСклада()
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	МенЗаписи = РегистрыСведений.уатАдресаСкладов_уэ.СоздатьМенеджерЗаписи();
	МенЗаписи.Склад = Объект.Ссылка;
	МенЗаписи.Прочитать();
	АдресСклада = МенЗаписи.Адрес;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьАдресСклада()
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	МенЗаписи = РегистрыСведений.уатАдресаСкладов_уэ.СоздатьМенеджерЗаписи();
	МенЗаписи.Склад = Объект.Ссылка;
	МенЗаписи.Адрес = АдресСклада;
	МенЗаписи.Записать();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	 Элементы.ТранзитнаяЯчейка.Доступность = Объект.АдресноеХранение;
	 Элементы.РазделительНаименованияЯчеек.Доступность = Объект.АдресноеХранение;
КонецПроцедуры

#КонецОбласти
