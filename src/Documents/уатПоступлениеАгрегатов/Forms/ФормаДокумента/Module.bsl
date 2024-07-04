
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
	
	// Инициализация реквизитов формы.	
	Контрагент = Объект.Контрагент;
	Если НЕ Объект.Ссылка.Пустая() ИЛИ НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		Договор = Объект.ДоговорКонтрагента;
	КонецЕсли;
	ВалютаРасчетов = Объект.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	
	Если Не ЗначениеЗаполнено(Объект.ВалютаДокумента) Тогда
		Объект.ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;
	ВалютаРасчетовКурсКратность    = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Объект.Дата, 
												Новый Структура("Валюта", Объект.ВалютаДокумента));
	КурсВзаиморасчетов      = ?(ВалютаРасчетовКурсКратность.Курс = 0, 1, ВалютаРасчетовКурсКратность.Курс);
	КратностьВзаиморасчетов = ?(ВалютаРасчетовКурсКратность.Кратность = 0, 1,ВалютаРасчетовКурсКратность.Кратность);
	
	уатОбщегоНазначенияСервер.НастроитьПолеДоговорКонтрагента(Элементы.ДоговорКонтрагента, "Объект.Организация", "Объект.Контрагент", "СПоставщиком");
	уатОбщегоНазначенияСервер.НастроитьПолеПодразделение(Элементы.Подразделение, "Объект.Организация");
	
	// уатУправлениеАвтотранспортом.МодификацияКонфигурации
	уатМодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец уатУправлениеАвтотранспортом.МодификацияКонфигурации
	
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
	
	// уатУправлениеАвтотранспортом.МодификацияКонфигурации
	уатМодификацияКонфигурацииКлиентПереопределяемый.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец уатУправлениеАвтотранспортом.МодификацияКонфигурации
	
	уатЗащищенныеФункцииКлиент.уатДокументФормаЭлементаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		уатОбщегоНазначенияКлиент.ПриИзмененииДоговора(ЭтаФорма, Неопределено, Договор);
	КонецЕсли;
		
	ВывестиСуммовыеИтогиДокумента();
	
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
		РассчитатьСуммуДокумента();
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

// уатУправлениеАвтотранспортом.МодификацияКонфигурации
&НаКлиенте
Процедура Подключаемый_ПолеФормыНажатие(Элемент, СтандартнаяОбработка)
	
	уатМодификацияКонфигурацииКлиентПереопределяемый.ПолеФормыНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ПриИзмененииКонтрагентаИлиОрганизации(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	КонтрагентПередИзменением = Контрагент;
	Контрагент = Объект.Контрагент;
	ДоговорПередИзменением = Объект.ДоговорКонтрагента;
	
	Если КонтрагентПередИзменением <> Объект.Контрагент Тогда
		
		ПриИзмененииКонтрагентаИлиОрганизации(Неопределено);
		уатОбщегоНазначенияКлиент.ПриИзмененииДоговора(ЭтаФорма, Неопределено, ДоговорПередИзменением);
				
		Для Каждого СтрокаТабличнойЧасти Из Объект.Шины Цикл
			СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(СтрокаТабличнойЧасти.СерияНоменклатуры, Объект.ВалютаДокумента, Объект.Дата);
			ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти, СтруктураДанные.Модель);
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
				СтрокаТабличнойЧасти.Цена = СтруктураДанные.ПервоначальнаяСтоимость;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.Аккумуляторы Цикл
			СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(СтрокаТабличнойЧасти.СерияНоменклатуры, Объект.ВалютаДокумента, Объект.Дата);
			ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти, СтруктураДанные.Модель);
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
				СтрокаТабличнойЧасти.Цена = СтруктураДанные.ПервоначальнаяСтоимость;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.ПрочиеАгрегаты Цикл
			СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(СтрокаТабличнойЧасти.СерияНоменклатуры, Объект.ВалютаДокумента, Объект.Дата);
			ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти, СтруктураДанные.Модель);
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
				СтрокаТабличнойЧасти.Цена = СтруктураДанные.ПервоначальнаяСтоимость;
			КонецЕсли;
		КонецЦикла;

		РассчитатьСуммуДокумента();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	Оповещ = Новый ОписаниеОповещения("ДоговорКонтрагентаПриИзмененииЗавершение", ЭтотОбъект);
	уатОбщегоНазначенияКлиент.ДоговорКонтрагентаПриИзменении(ЭтаФорма, Оповещ);
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзмененииЗавершение(Результат, ДопПараметры) Экспорт
	уатОбщегоНазначенияКлиент.ПриИзмененииДоговора(ЭтаФорма, Неопределено, Договор);
КонецПроцедуры

// Вызывается из процедуры уатОбщегоНазначенияКлиент.ПриИзмененииДоговора()
//
&НаКлиенте
Процедура ПриИзмененииДоговораЛокальныеОбработчики() Экспорт
	ВывестиСуммовыеИтогиДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаСоздание(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВидДоговораДоступныеЗначения = Новый Массив;
	
	мВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком");
	ВидДоговораДоступныеЗначения.Добавить(мВидДоговора);
	
	ПараметрыФормы = Новый Структура();       
	ПараметрыФормы.Вставить("Владелец", Объект.Контрагент);
	ПараметрыФормы.Вставить("ВидДоговораДоступныеЗначения", ВидДоговораДоступныеЗначения);
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШины

&НаКлиенте
Процедура ШиныОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		Для Каждого ТекЭлем Из ВыбранноеЗначение Цикл
			НовСтрока = Объект.Шины.Добавить();
			НовСтрока.СерияНоменклатуры = ТекЭлем.Значение;
			НовСтрока.Цена = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТекЭлем.Значение, "ПервоначальнаяСтоимость");
			Если НЕ ЗначениеЗаполнено(НовСтрока.Цена) Тогда
				СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(НовСтрока.СерияНоменклатуры, Объект.ВалютаДокумента, Объект.Дата);
				ЗаполнитьЦенуПоКонтрагенту(НовСтрока, СтруктураДанные.Модель);
			КонецЕсли;
		КонецЦикла;
		РассчитатьСуммуДокумента();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШиныСерияНоменклатурыПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Шины.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(СтрокаТабличнойЧасти.СерияНоменклатуры, Объект.ВалютаДокумента, Объект.Дата);
	ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти, СтруктураДанные.Модель);
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
		СтрокаТабличнойЧасти.Цена = СтруктураДанные.ПервоначальнаяСтоимость;
	КонецЕсли;
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ШиныПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ШиныПослеУдаления(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАккумуляторы

&НаКлиенте
Процедура АккумуляторыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		Для Каждого ТекЭлем Из ВыбранноеЗначение Цикл
			НовСтрока = Объект.Аккумуляторы.Добавить();
			НовСтрока.СерияНоменклатуры  = ТекЭлем.Значение;
			Если НЕ ЗначениеЗаполнено(НовСтрока.Цена) Тогда
				СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(НовСтрока.СерияНоменклатуры, Объект.ВалютаДокумента, Объект.Дата);
				ЗаполнитьЦенуПоКонтрагенту(НовСтрока, СтруктураДанные.Модель);
			КонецЕсли;
		КонецЦикла;
		РассчитатьСуммуДокумента();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АккумуляторыСерияНоменклатурыПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Аккумуляторы.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(СтрокаТабличнойЧасти.СерияНоменклатуры, Объект.ВалютаДокумента, Объект.Дата);
	ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти, СтруктураДанные.Модель);
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
		СтрокаТабличнойЧасти.Цена = СтруктураДанные.ПервоначальнаяСтоимость;
	КонецЕсли;
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура АккумуляторыПослеУдаления(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура АккумуляторыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	РассчитатьСуммуДокумента();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрочиеАгрегаты

&НаКлиенте
Процедура ПрочиеАгрегатыПослеУдаления(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАгрегатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАгрегатыСерияНоменклатурыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("ТипАгрегата, РежимВыбора", "ПрочиеАгрегаты", Истина);
	ОткрытьФорму("Справочник.уатСерииНоменклатуры.ФормаВыбора", ПараметрыФормы, Элемент);	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАгрегатыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		
		Для Каждого ТекЭлем Из ВыбранноеЗначение Цикл
			ТипАгрегата = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТекЭлем.Значение, "ТипАгрегата");
			
			Если ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Аккумулятор") Тогда
				ТекстНСТР = Нстр("en='In the tabular section ""Other car parts"", it is not possible to add tires and batteries."
" The generated list is batteries';ru='В табличную часть ""Прочие агрегаты"" невозможно добавление шин и аккумуляторов. "
" Сформированный список является аккумуляторами'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				Возврат;
				
			ИначеЕсли ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина") Тогда
				ТекстНСТР = Нстр("en='In the tabular section ""Other car parts"", it is not possible to add tires and batteries."
" The generated list is tires';ru='В табличную часть ""Прочие агрегаты"" невозможно добавление шин и аккумуляторов. "
" Сформированный список является шинами'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				Возврат;
				
			КонецЕсли;
			
			НовСтрока = Объект.ПрочиеАгрегаты.Добавить();
			НовСтрока.СерияНоменклатуры = ТекЭлем.Значение;
			Если НЕ ЗначениеЗаполнено(НовСтрока.Цена) Тогда
				СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(НовСтрока.СерияНоменклатуры, Объект.ВалютаДокумента, Объект.Дата);
				ЗаполнитьЦенуПоКонтрагенту(НовСтрока, СтруктураДанные.Модель);
			КонецЕсли;
		КонецЦикла;
		РассчитатьСуммуДокумента();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАгрегатыСерияНоменклатурыПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ПрочиеАгрегаты.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(СтрокаТабличнойЧасти.СерияНоменклатуры, Объект.ВалютаДокумента, Объект.Дата);
	ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти, СтруктураДанные.Модель);
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
		СтрокаТабличнойЧасти.Цена = СтруктураДанные.ПервоначальнаяСтоимость;
	КонецЕсли;
	РассчитатьСуммуДокумента();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// уатУправлениеАвтотранспортом.МодификацияКонфигурации
&НаКлиенте
Процедура Подключаемый_уатВыполнитьКоманду(Команда)
	
	уатМодификацияКонфигурацииКлиентПереопределяемый.ВыполнитьПодключаемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры
// Конец уатУправлениеАвтотранспортом.МодификацияКонфигурации

&НаКлиенте
Процедура ШиныПакетныйВвод(Команда)
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", Новый Структура("ТипАгрегата", 
								ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина")));
	
	ОткрытьФорму("Обработка.уатПакетныйВводАгрегатов.Форма", ПараметрыОткрытия, Элементы.Шины);
КонецПроцедуры

&НаКлиенте
Процедура ШиныУстановитьСтоимость(Команда)
	мЦена = 0;
	ТекстНСТР = НСтр("en='Tire cost';ru='Стоимость шины'");
	ПоказатьВводЧисла(Новый ОписаниеОповещения("ШиныУстановитьСтоимостьЗавершение", ЭтотОбъект,
		Новый Структура("мЦена", мЦена)), мЦена, ТекстНСТР, 15, 2);
КонецПроцедуры

&НаКлиенте
Процедура ШиныУстановитьПробег(Команда)
	мПробег = 0;
	ТекстНСТР = НСтр("en='The initial mileage of tyres';ru='Начальный пробег шины'");
	ПоказатьВводЧисла(Новый ОписаниеОповещения("ШиныУстановитьПробегЗавершение", ЭтотОбъект,
		Новый Структура("мПробег", мПробег)), мПробег, ТекстНСТР, 15, 2);
КонецПроцедуры

 &НаКлиенте
Процедура ШиныОчистить(Команда)
	Если Объект.Шины.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Cleaning will be performed on list of tires. Continue?';ru='Будет выполнена очистка списка шин. Продолжить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ШиныОчиститьЗавершение", ЭтотОбъект),
			ТекстНСТР, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЦеныИВалюту(Команда)
	ОбработатьИзмененияПоКнопкеЦеныИВалюты(Новый ОписаниеОповещения("РедактироватьЦеныИВалютуЗавершение", ЭтотОбъект), Объект.ВалютаДокумента);
КонецПроцедуры

&НаКлиенте
Процедура ПодборШин(Команда)
	ДействиеПодбор("Шины");
КонецПроцедуры

&НаКлиенте
Процедура АккумуляторыПакетныйВвод(Команда)
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", Новый Структура("ТипАгрегата",
								ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Аккумулятор")));
	
	ОткрытьФорму("Обработка.уатПакетныйВводАгрегатов.Форма", ПараметрыОткрытия, Элементы.Аккумуляторы);
КонецПроцедуры

&НаКлиенте
Процедура АккумуляторыОчистить(Команда)
	Если Объект.Аккумуляторы.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Battery list will be cleared. Continue?';ru='Будет выполнена очистка списка аккумуляторов. Продолжить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("АккумуляторыОчиститьЗавершение", ЭтотОбъект),
			ТекстНСТР, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АккумуляторыУстановитьЦену(Команда)
	мЦена = 0;
	ТекстНСТР = НСтр("en='Cost of batteries';ru='Стоимость аккумуляторов'");
	ПоказатьВводЧисла(Новый ОписаниеОповещения("АккумуляторыУстановитьЦенуЗавершение", ЭтотОбъект,
		Новый Структура("мЦена", мЦена)), мЦена, ТекстНСТР, 15, 2);
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАгрегатыПакетныйВвод(Команда)
	ОткрытьФорму("Обработка.уатПакетныйВводАгрегатов.Форма", , Элементы.ПрочиеАгрегаты);
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАгрегатыОчистить(Команда)
	Если Объект.ПрочиеАгрегаты.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='List of other car parts will be cleared. Continue?';ru='Будет выполнена очистка списка прочих агрегатов. Продолжить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ПрочиеАгрегатыОчиститьЗавершение", ЭтотОбъект),
			ТекстНСТР, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАгрегатыУстановитьЦену(Команда)
	мЦена = 0;
	ТекстНСТР = НСтр("en='Car parts cost';ru='Стоимость агрегатов'");
	ПоказатьВводЧисла(Новый ОписаниеОповещения("ПрочиеАгрегатыУстановитьЦенуЗавершение", ЭтотОбъект,
		Новый Структура("мЦена", мЦена)), мЦена, ТекстНСТР, 15, 2);
КонецПроцедуры

&НаКлиенте
Процедура ПодборАккумуляторов(Команда)
	ДействиеПодбор("Аккумуляторы");
КонецПроцедуры

&НаКлиенте
Процедура ПодборПрочихАгрегатов(Команда)
	ДействиеПодбор("ПрочиеАгрегаты");
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

&НаСервереБезКонтекста
Функция ПолучитьДанныеСерияНоменклатурыПриИзменении(СерияНоменклатуры, ВалютаДокумента, ДатаДокумента)
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("ПервоначальнаяСтоимость"	, СерияНоменклатуры.ПервоначальнаяСтоимость);
	СтруктураДанные.Вставить("Валюта"					, СерияНоменклатуры.Валюта);
	СтруктураДанные.Вставить("Модель"					, СерияНоменклатуры.Модель);
	
	Если НЕ ЗначениеЗаполнено(СтруктураДанные.Валюта) Тогда
		СтруктураДанные.Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;
	
	Если СтруктураДанные.Валюта <> ВалютаДокумента Тогда
		СтруктураДанные.ПервоначальнаяСтоимость =
			уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(СтруктураДанные.ПервоначальнаяСтоимость,
			СтруктураДанные.Валюта,	ВалютаДокумента,
			ДатаДокумента, ДатаДокумента);
	КонецЕсли;
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаКлиенте
Процедура ПриИзмененииКонтрагентаИлиОрганизации(Знач Оповещение)
	ДанныеОбменаССервером = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, Дата");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, Объект);
	// Получим данные с сервера
	ДанныеОбменаССервером.ДоговорКонтрагента = Объект.ДоговорКонтрагента;
	ЗначенияДляЗаполнения = ИзменениеКонтрагентаСервер(ДанныеОбменаССервером);
	Объект.ДоговорКонтрагента = ЗначенияДляЗаполнения.ДоговорКонтрагента;
	
	ДоговорПередИзменением = Договор;
	//Договор = Объект.ДоговорКонтрагента;
	
	Оповещ = Новый ОписаниеОповещения("ПриИзмененииКонтрагентаИлиОрганизацииЗавершение", ЭтотОбъект, Новый Структура("Оповещение", Оповещение));
	уатОбщегоНазначенияКлиент.ПриИзмененииДоговора(ЭтаФорма, Оповещ, ДоговорПередИзменением);
КонецПроцедуры // ПриИзмененииКонтрагентаИлиОрганизации()

&НаКлиенте
Процедура ПриИзмененииКонтрагентаИлиОрганизацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Оповещение = ДополнительныеПараметры.Оповещение;
	Если Не Оповещение = Неопределено Тогда 
		ВыполнитьОбработкуОповещения(Оповещение);
	КонецЕсли;

КонецПроцедуры // ПриИзмененииКонтрагентаИлиОрганизации()

&НаСервереБезКонтекста
Функция ИзменениеКонтрагентаСервер(ДанныеДляЗаполнения)
	СтруктураПараметровДляПолученияДоговора = 
		уатЗаполнениеДокументов.ПолучитьСтруктуруПараметровДляПолученияДоговораПокупки();
	
	ЗначенияДляЗаполнения = уатОбщегоНазначенияСервер.ПриИзмененииЗначенияКонтрагента(ДанныеДляЗаполнения,
							СтруктураПараметровДляПолученияДоговора);
	Возврат ЗначенияДляЗаполнения;
КонецФункции

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
	СтруктураОтбора = Новый Структура("СерияНоменклатуры", Агрегат);
		
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
		
		СтруктураДанные = ПолучитьДанныеСерияНоменклатурыПриИзменении(Агрегат, Объект.ВалютаДокумента, Объект.Дата);
		ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти, СтруктураДанные.Модель);
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
			СтрокаТабличнойЧасти.Цена = СтруктураДанные.ПервоначальнаяСтоимость;
		КонецЕсли;
		РассчитатьСуммуДокумента();
	КонецЕсли;
	
КонецПроцедуры //

&НаКлиенте
Процедура ШиныУстановитьСтоимостьЗавершение(Число, ДополнительныеПараметры) Экспорт
    
    мЦена = ?(Число = Неопределено, ДополнительныеПараметры.мЦена, Число);
    
    
    Если (Число <> Неопределено) Тогда
        Для Каждого ТекСтрока Из Объект.Шины Цикл
            ТекСтрока.Цена = мЦена;
		КонецЦикла;
		РассчитатьСуммуДокумента();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ШиныУстановитьПробегЗавершение(Число, ДополнительныеПараметры) Экспорт
    
    мПробег = ?(Число = Неопределено, ДополнительныеПараметры.мПробег, Число);
    
    
    Если (Число <> Неопределено) Тогда
        Для Каждого ТекСтрока Из Объект.Шины Цикл
            ТекСтрока.Пробег = мПробег;
        КонецЦикла;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ШиныОчиститьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        Объект.Шины.Очистить();
		РассчитатьСуммуДокумента();
    КонецЕсли;

КонецПроцедуры

// Процедура выполняет пересчет в табличной части документа после изменений 
// в форме "Цены и валюта".Выполняется пересчет колонок: цена, скидка, сумма,
// сумма НДС, всего.
//
&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалюты(Знач Оповещение, Знач ВалютаРасчетовПередИзменением, ПересчитатьЦены = Ложь)
	
	// 1. Формируем структуру параметров для заполнения формы "Цены и Валюта".
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВалютаДокумента",		  Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("Контрагент",			  Объект.Контрагент);
	СтруктураПараметров.Вставить("КурсДокумента",		КурсВзаиморасчетов);
	СтруктураПараметров.Вставить("КратностьДокумента",  КратностьВзаиморасчетов);
	СтруктураПараметров.Вставить("Организация",			  Объект.Организация);
	СтруктураПараметров.Вставить("ДатаДокумента",		  Объект.Дата);
	СтруктураПараметров.Вставить("ПерезаполнитьЦены",	  Ложь);
	СтруктураПараметров.Вставить("ПересчитатьЦены",		  ПересчитатьЦены);
	СтруктураПараметров.Вставить("БылиВнесеныИзменения",  Ложь);
	
	СтруктураЦеныИВалюта = Неопределено;

	Если НЕ ПравоРедактированиеДокумента() Тогда
		СтруктураПараметров.Вставить("ТолькоПросмотр", Истина);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаЦеныИВалюта", СтруктураПараметров,,,,, Новый ОписаниеОповещения("ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение", ЭтотОбъект, Новый Структура("ВалютаРасчетовПередИзменением, Оповещение", ВалютаРасчетовПередИзменением, Оповещение)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено ИЛИ НЕ ПравоРедактированиеДокумента() Тогда
		Возврат;
	КонецЕсли;
	
    ВалютаРасчетовПередИзменением = ДополнительныеПараметры.ВалютаРасчетовПередИзменением;
    Оповещение = ДополнительныеПараметры.Оповещение;
        
    // 2. Открываем форму "Цены и Валюта".
    СтруктураЦеныИВалюта = Результат;
    
    // 3. Перезаполняем табличную часть "Номенклатура", если были внесены изменения в форме "Цены и Валюта".
    Если ТипЗнч(СтруктураЦеныИВалюта) = Тип("Структура") Тогда
        
        // Для объедининенного решения с БП 3
        уатОбщегоНазначенияКлиент.ЗаполнитьСтруктуруЦеныИВалютыДляБП3(СтруктураЦеныИВалюта,Объект.ВалютаДокумента,ВалютаРасчетовПередИзменением);
        // Для объедининенного решения с БП 3
        Если СтруктураЦеныИВалюта.Свойство("ВалютаДокумента") И СтруктураЦеныИВалюта.Свойство("Курс") И СтруктураЦеныИВалюта.Свойство("Кратность") Тогда
            Объект.ВалютаДокумента		   = СтруктураЦеныИВалюта.ВалютаДокумента;
            КурсВзаиморасчетов             = СтруктураЦеныИВалюта.Курс;
            КратностьВзаиморасчетов 	   = СтруктураЦеныИВалюта.Кратность;
        КонецЕсли;
        
        // Пересчитываем цены по валюте.
        Если СтруктураЦеныИВалюта.Свойство("ПересчитатьЦены") Тогда
            Если СтруктураЦеныИВалюта.ПересчитатьЦены Тогда	
                ПересчитатьЦеныТабличнойЧастиПоВалюте(ВалютаРасчетовПередИзменением, "Шины");
                ПересчитатьЦеныТабличнойЧастиПоВалюте(ВалютаРасчетовПередИзменением, "Аккумуляторы");
                ПересчитатьЦеныТабличнойЧастиПоВалюте(ВалютаРасчетовПередИзменением, "ПрочиеАгрегаты");
            КонецЕсли;
        КонецЕсли;
    КонецЕсли;
    
    РассчитатьСуммуДокумента();
	
	Если Не Оповещение = Неопределено Тогда 
		ВыполнитьОбработкуОповещения(Оповещение);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЦеныИВалютуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РассчитатьСуммуДокумента();
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура АккумуляторыОчиститьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        Объект.Аккумуляторы.Очистить();
		РассчитатьСуммуДокумента();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура АккумуляторыУстановитьЦенуЗавершение(Число, ДополнительныеПараметры) Экспорт
    
    мЦена = ?(Число = Неопределено, ДополнительныеПараметры.мЦена, Число);
    
    
    Если (Число <> Неопределено) Тогда
        Для Каждого ТекСтрока Из Объект.Аккумуляторы Цикл
            ТекСтрока.Цена = мЦена;
		КонецЦикла;
		РассчитатьСуммуДокумента();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАгрегатыОчиститьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        Объект.ПрочиеАгрегаты.Очистить();
		РассчитатьСуммуДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАгрегатыУстановитьЦенуЗавершение(Число, ДополнительныеПараметры) Экспорт
    
    мЦена = ?(Число = Неопределено, ДополнительныеПараметры.мЦена, Число);
    
    
    Если (Число <> Неопределено) Тогда
        Для Каждого ТекСтрока Из Объект.ПрочиеАгрегаты Цикл
            ТекСтрока.Цена = мЦена;
		КонецЦикла;
		РассчитатьСуммуДокумента();
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ВывестиСуммовыеИтогиДокумента()
	
	НадписьВсего = НСтр("en='Total';ru='Всего'");
	
	Если Не ЗначениеЗаполнено(Объект.ВалютаДокумента) Или Объект.ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить() Тогда 
		НадписьКурс = "(1.0000)";
		Элементы.НадписьКурс2.Видимость = Ложь;
	Иначе 
		НадписьКурс = "(" + Формат(КурсВзаиморасчетов, "ЧДЦ=4; ЧРД=.; ЧН=0.0000; ЧГ=0") + ")";
		Элементы.НадписьКурс2.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПравоРедактированиеДокумента()
	Рез = ПравоДоступа("Редактирование", Метаданные.Документы.уатПоступлениеАгрегатов);
	Возврат Рез;
КонецФункции

&НаСервере
Процедура ПересчитатьЦеныТабличнойЧастиПоВалюте(ВалютаРасчетовПередИзменением, ИмяТЧ)
	уатОбщегоНазначенияСервер.ПересчитатьЦеныТабличнойЧастиПоВалюте(Объект, ВалютаРасчетовПередИзменением, ИмяТЧ);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти, Модель)
	
	Если ЗначениеЗаполнено(Модель) Тогда
		СтруктураЦенаВалюта = уатОбщегоНазначения.уатНайтиЦенуНоменклатуры(Объект.Дата, Модель, Объект.Контрагент, Ложь);
		мЦена = 0;
		Если ЗначениеЗаполнено(СтруктураЦенаВалюта.Цена) Тогда
			мЦена = СтруктураЦенаВалюта.Цена;
			мЦена = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(мЦена,
				СтруктураЦенаВалюта.Валюта,	Объект.ВалютаДокумента,
				Объект.Дата, Объект.Дата);
		КонецЕсли;
		СтрокаТабличнойЧасти.Цена = мЦена;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Шины.Итог("Цена") + Объект.Аккумуляторы.Итог("Цена") + Объект.ПрочиеАгрегаты.Итог("Цена");
	ВывестиСуммовыеИтогиДокумента();
	
КонецПроцедуры

#КонецОбласти
