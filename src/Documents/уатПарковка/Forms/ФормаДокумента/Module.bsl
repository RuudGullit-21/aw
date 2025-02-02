#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ВалютаДокумента = мВалютаРегламентированногоУчета;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатДокументФормаЭлементаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	ОбновитьСписокВыбораЭкипажа();
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
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТСПриИзменении(Элемент)
	
	Объект.Водитель = Неопределено;
	Если ЗначениеЗаполнено(Объект.Запущена) Тогда //из ПЛ
		ЗаполнитьЗначенияСвойств(Объект, ВодительТСпоПЛ(Объект.ТС, Объект.Запущена));
	КонецЕсли;
	
	// установим текущее местонахождение ТС
	МестонахождениеТС = уатОбщегоНазначения.МестонахождениеТС(Объект.ТС, Объект.Дата);
	Если НЕ ЗначениеЗаполнено(Объект.Колонна) Тогда
		Объект.Колонна = МестонахождениеТС.Колонна;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.Организация = МестонахождениеТС.Организация;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
		Объект.Подразделение = МестонахождениеТС.Подразделение;
	КонецЕсли;
	
	ОбновитьСписокВыбораЭкипажа(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	уатИнтерфейсВводаТС.РеквизитТСНачалоВыбора(Элемент, Объект.ТС, ДанныеВыбора,
		СтандартнаяОбработка, СтруктураОтборТС());
КонецПроцедуры

&НаКлиенте
Процедура ТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	уатИнтерфейсВводаТС.РеквизитТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание,
		СтандартнаяОбработка, СтруктураОтборТС());
КонецПроцедуры

&НаКлиенте
Процедура ТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	уатИнтерфейсВводаТС.РеквизитТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных,
		СтандартнаяОбработка, СтруктураОтборТС());
КонецПроцедуры

&НаКлиенте
Процедура ВодительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	уатЗащищенныеФункцииКлиент.ДиалогВыбораСотрудника(Элемент, Объект.Водитель, Новый Структура("Организация", Объект.Организация), СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВодительОткрытие(Элемент, СтандартнаяОбработка)
	уатЗащищенныеФункцииКлиент.ОткрытьФормуСотрудника(Объект.Водитель, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВодительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если Ожидание = 0 Тогда //выбор из списка
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("Организация, ДатаСреза", Объект.Организация, Объект.Дата);
	уатИнтерфейсВводаСотрудников.СотрудникАвтоПодборТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка, СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура ВодительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СтруктураПараметров = Новый Структура("Организация, ДатаСреза", Объект.Организация, Объект.Дата);
	уатИнтерфейсВводаСотрудников.СотрудникОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка, СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура ЗапущенаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ТС) Тогда
		Если ЗначениеЗаполнено(Объект.Запущена) Тогда
			ТекстНСТР = НСтр("en='Changed the date of violation. Search through the relevant waybills?';ru='Изменилась дата запуска парковочной сессии. Произвести поиск по соответствующим путевым листам?'");
			ПоказатьВопрос(Новый ОписаниеОповещения("ЗапущенаПриИзмененииЗавершение", ЭтотОбъект),
				ТекстНСТР, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет);
		КонецЕсли;	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

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

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервереБезКонтекста
Функция ВодительТСпоПЛ(ТС, мДата)
	
	Возврат Документы.уатШтраф.ВодительТСпоПЛ(ТС, мДата);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокВыбораЭкипажа()
	Элементы.Водитель.СписокВыбора.Очистить();
	
	ЭкипажТССписок = уатЗащищенныеФункцииСервер.ЭкипажТССписок(Объект.ТС, Объект.Дата);
	ЭкипажТССписок_Количество = ЭкипажТССписок.Количество();
	
	Элементы.Водитель.КнопкаВыпадающегоСписка = (ЭкипажТССписок_Количество > 0);
	
	Если ЭкипажТССписок_Количество = 0 Тогда	
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекСотр Из ЭкипажТССписок Цикл
		Элементы.Водитель.СписокВыбора.Добавить(ТекСотр.Значение);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗапущенаПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Запущена) Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВодительТСпоПЛ(Объект.ТС, Объект.Запущена));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапущенаПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗапущенаПриИзмененииНаСервере();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Функция СтруктураОтборТС()
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		СтруктураОтбор.Вставить("Подразделение", Объект.Подразделение);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Колонна) Тогда
		СтруктураОтбор.Вставить("Колонна", Объект.Колонна);
	КонецЕсли;
	
	Возврат СтруктураОтбор;
КонецФункции

#КонецОбласти
