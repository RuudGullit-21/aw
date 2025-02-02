
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	уатОбщегоНазначенияСервер.НастроитьПолеПодразделение(Элементы.Подразделение, "Объект.Организация");
	
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
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Перем Команда;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		ВыбранноеЗначение.Свойство("Команда", Команда);
		
		Если Команда = "ПодборВТабличнуюЧастьШины" Тогда
			ОбработкаПодбора("Шины", ВыбранноеЗначение);
		ИначеЕсли Команда = "ПодборВТабличнуюЧастьАккумуляторы" Тогда
			ОбработкаПодбора("Аккумуляторы", ВыбранноеЗначение);
		ИначеЕсли Команда = "ПодборВТабличнуюЧастьПрочиеАгрегаты" Тогда
			ОбработкаПодбора("ПрочиеАгрегаты",ВыбранноеЗначение)	
		КонецЕсли;
	КонецЕсли;
	
	Модифицированность = Истина;
	
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
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_ПрочиеАгрегаты

&НаКлиенте
Процедура ПрочиеАгрегатыСерияНоменклатурыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("ТипАгрегата, РежимВыбора", "ПрочиеАгрегаты", Истина);
	ОткрытьФорму("Справочник.уатСерииНоменклатуры.ФормаВыбора", ПараметрыФормы, Элемент);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПодборАккумуляторов(Команда)
	ДействиеПодбор("Аккумуляторы");
КонецПроцедуры

&НаКлиенте
Процедура ПодборПрочихАгрегатов(Команда)
	ДействиеПодбор("ПрочиеАгрегаты");
КонецПроцедуры

&НаКлиенте
Процедура ПодборШин(Команда)
	ДействиеПодбор("Шины");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

&НаКлиенте
Процедура ДействиеПодбор(ИмяТабличнойЧасти)
	
	Если ИмяТабличнойЧасти = "Шины" Тогда
		Команда = "ПодборВТабличнуюЧастьШины";
	ИначеЕсли ИмяТабличнойЧасти = "Аккумуляторы" Тогда
		Команда = "ПодборВТабличнуюЧастьАккумуляторы";
	ИначеЕсли ИмяТабличнойЧасти =  "ПрочиеАгрегаты" Тогда
		Команда = "ПодборВТабличнуюЧастьПрочиеАгрегаты";
	КонецЕсли;
	СтруктураПараметровПодбора = Новый Структура();
	СтруктураПараметровПодбора.Вставить("Организация", Объект.Организация);
	СтруктураПараметровПодбора.Вставить("Команда", Команда);
	
	//СтруктураПараметровПодбора.Вставить("ПодбиратьУслуги", ЕстьУслуги);
	//СтруктураПараметровПодбора.Вставить("ОтборУслугПоСправочнику", Истина);
	
	ВременнаяДатаРасчетов = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	СтруктураПараметровПодбора.Вставить("ДатаРасчетов", ВременнаяДатаРасчетов);
	СтруктураПараметровПодбора.Вставить("Склад", Объект.Склад);
	
	уатОбщегоНазначенияТиповыеКлиент.уатОткрытьПодборАгрегатов(ЭтотОбъект, СтруктураПараметровПодбора);
	
КонецПроцедуры //

// Производит заполнение документа переданными из формы подбора данными.
//
// Параметры:
//  ТабличнаяЧасть    - табличная часть, в которую надо добавлять подобранную позицию агрегата;
//  ЗначениеВыбора    - структура, содержащая параметры подбора.
//
&НаКлиенте
Процедура ОбработкаПодбора(ИмяТабличнойЧасти, ЗначениеВыбора)
	
	Перем Агрегат, Модель;
	
	// Получим параметры подбора из структуры подбора.
	ЗначениеВыбора.Свойство("Агрегат",Агрегат);
	
	// Ищем выбранную позицию в таблице подобранных агрегатов.
	// Если найдем - выдаем сообщение; не найдем - добавим новую строку.
	СтруктураОтбора = Новый Структура();
	
	СтруктураОтбора.Вставить("СерияНоменклатуры",Агрегат);
		
	МассивСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивСтрок.Количество() = 0 Тогда
		СтрокаТабличнойЧасти = Неопределено;
	Иначе
		СтрокаТабличнойЧасти = МассивСтрок[0];
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		// Нашли, сообщаем.
		ТекстНСТР = НСтр("en='This car part was added earlier!';ru='Данный агрегат был добавлен раннее!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
	Иначе
		// Не нашли - добавляем новую строку.
		СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
		СтрокаТабличнойЧасти.СерияНоменклатуры	  = Агрегат;
	КонецЕсли;
	
КонецПроцедуры //

#КонецОбласти
