
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.УчетОригиналовПервчиныхДокументов
	УчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаДокумента(ЭтотОбъект, Элементы.ГруппаУчетПервичныхДокументов);
	уатУчетОригиналовПервичныхДокументов.ОтобразитьДатуПоследнегоИзмененияПервичныхДокументов(ЭтотОбъект, Элементы.ГруппаУчетПервичныхДокументов);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервчиныхДокументов

	// Установка реквизитов формы.
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Контрагент = Объект.Контрагент;
	Если НЕ Объект.Ссылка.Пустая() ИЛИ НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		Договор = Объект.ДоговорКонтрагента;
	КонецЕсли;
	ВалютаРасчетов = Объект.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	НациональнаяВалюта = мВалютаРегламентированногоУчета;
	СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Объект.Дата, Новый Структура("Валюта",
																									НациональнаяВалюта));
	КурсНациональнаяВалюта = СтруктураПоВалюте.Курс;
	КратностьНациональнаяВалюта = СтруктураПоВалюте.Кратность;
	
	уатОбщегоНазначенияСервер.НастроитьПолеЕдиницыИзмерения(ЭтотОбъект, "Товары");
	уатОбщегоНазначенияСервер.НастроитьПолеПодразделение(Элементы.Подразделение, "Объект.Организация");
	уатОбщегоНазначенияСервер.НастроитьПолеДоговорКонтрагента(Элементы.ДоговорКонтрагента, "Объект.Организация", "Объект.Контрагент", "СПоставщиком");
	
	ОрганизацияПередИзменением = Объект.Организация;
	
	ОбновитьВсегоВТЧСервер();
	
	//ПодключаемоеОборудование
	уатОбщегоНазначения_проф.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	//Конец ПодключаемоеОборудование
	
	// уатУправлениеАвтотранспортом.МодификацияКонфигурации
	уатМодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец уатУправлениеАвтотранспортом.МодификацияКонфигурации
	
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
	
	Если Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		уатОбщегоНазначенияКлиент.ПриИзмененииДоговора(ЭтаФорма, Неопределено, Договор);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//ПодключаемоеОборудование
	уатОбщегоНазначенияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтотОбъект);
	//Конец ПодключаемоеОборудование
	
	// Установить видимость реквизитов и заголовков колонок.
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Обработка.уатПодборНоменклатуры.Форма.Форма" или ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаПодбора(ИсточникВыбора.ИмяТаблицы, ВыбранноеЗначение);
	ИначеЕсли   ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументЗакупки.Форма.Форма" Тогда
		ОбработкаПодбора("Товары", ВыбранноеЗначение);      
	КонецЕсли;
	Модифицированность = Истина;
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
	
	ОбновитьВсегоВТЧСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьВсегоВТЧСервер();
	
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

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если флВопросЗакрытиеФормы Тогда
		Отказ = Истина;
		Оповещ = Новый ОписаниеОповещения("ПередЗакрытиемВопрос", ЭтотОбъект);
		ПоказатьВопрос(Оповещ, "При проверке корректности заполнения документа возникли предупреждения!
			|Продолжить закрытие формы?", РежимДиалогаВопрос.ОКОтмена);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопрос(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.ОК Тогда
		флВопросЗакрытиеФормы = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов	
	УчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаДокумента(ИмяСобытия, ЭтотОбъект);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Оповещ = Новый ОписаниеОповещения("ДобавитьНоменклатуруВТЧПоШтрихкоду", ЭтотОбъект);
		уатОбщегоНазначенияКлиент.ОбработатьСобытиеПодключаемогоОборудования(ИмяСобытия, Параметр, Источник,
			Новый Структура("Оповещение", Оповещ));
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	// ПодключаемоеОборудование
	уатОбщегоНазначенияКлиент.ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	// Конец ПодключаемоеОборудование
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

// уатУправлениеАвтотранспортом.МодификацияКонфигурации
&НаКлиенте
Процедура Подключаемый_ПолеФормыНажатие(Элемент, СтандартнаяОбработка)
	
	уатМодификацияКонфигурацииКлиентПереопределяемый.ПолеФормыНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДекорацияСостояниеОригиналаНажатие()

	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ОткрытьМенюВыбораСостояния(ЭтотОбъект, Элементы.ДекорацияСостояниеОригинала);
	//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Объект.Организация = ОрганизацияПередИзменением Тогда
		Возврат;
	КонецЕсли;
	ОрганизацияПередИзменением = Объект.Организация;
	
	// Обработка события изменения организации.
	Если НЕ уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Объект.Организация,
		ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.ВестиСкладскойУчетУАТ")) Тогда
		
		ТекстНСТР = НСтр("en='For company ""%1"" the possibility of inventory management with FMS documents is disabled!';ru='Для организации ""%1"" отключена возможность ведения складского учета документами УАТ!'");
		ТекстНСТР = СтрШаблон(ТекстНСТР, Объект.Организация);
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ОрганизацияПриИзмененииФрагмент", ЭтотОбъект), ТекстНСТР, 5);
        Возврат;
	КонецЕсли;

	ОрганизацияПриИзмененииФрагмент(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзмененииФрагмент(ДополнительныеПараметры) Экспорт
    
    ПриИзмененииКонтрагентаИлиОрганизации(Новый ОписаниеОповещения("ОрганизацияПриИзмененииФрагментЗавершение", ЭтотОбъект));

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзмененииФрагментЗавершение(Результат, ДополнительныеПараметры) Экспорт
	УчитыватьНДСПередИзменением = Объект.УчитыватьНДС;
	СуммаВключаетНДСПередИзменением = Объект.СуммаВключаетНДС;
	
	Объект.УчитыватьНДС = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Объект.Организация,
		ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.УчитыватьНДС"));
	Объект.СуммаВключаетНДС = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Объект.Организация,
		ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.СуммаВключаетНДС"));
		
	Если Объект.УчитыватьНДС <> УчитыватьНДСПередИзменением ИЛИ Объект.СуммаВключаетНДС <> СуммаВключаетНДСПередИзменением Тогда
		ЗаполнитьСтавкуНДСПоНалогообложениеНДС();
		ПересчитататьНДС();
    	УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПередИзменением = Контрагент;
	Контрагент = Объект.Контрагент;
	
	Если КонтрагентПередИзменением <> Объект.Контрагент Тогда
		ПриИзмененииКонтрагентаИлиОрганизации(Неопределено);
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл
			ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти);
		КонецЦикла;
		
		ОбновитьВсегоВТЧТовары();
		ВывестиСуммовыеИтогиДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	Оповещ = Новый ОписаниеОповещения("ДоговорКонтрагентаПриИзмененииЗавершение", ЭтотОбъект);
	уатОбщегоНазначенияКлиент.ДоговорКонтрагентаПриИзменении(ЭтаФорма, Оповещ);
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
Процедура ДоговорКонтрагентаПриИзмененииЗавершение(Результат, ДопПараметры) Экспорт
	уатОбщегоНазначенияКлиент.ПриИзмененииДоговора(ЭтаФорма, Неопределено, Договор);
КонецПроцедуры

// Вызывается из процедуры уатОбщегоНазначенияКлиент.ПриИзмененииДоговора()
//
&НаКлиенте
Процедура ПриИзмененииДоговораЛокальныеОбработчики() Экспорт
	РассчитатьСуммуДокумента();
	ОбновитьВсегоВТЧТовары();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Номенклатура",	 СтрокаТабличнойЧасти.Номенклатура);

	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество) тогда
		СтрокаТабличнойЧасти.Количество = 1;
	КонецЕсли;
	
	ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти);
	
	Если Объект.УчитыватьНДС Тогда
		СтавкаНДС = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(
			СтрокаТабличнойЧасти.Номенклатура, "СтавкаНДС");
		СтрокаТабличнойЧасти.СтавкаНДС = ?(ЗначениеЗаполнено(СтавкаНДС), СтавкаНДС, СтрокаТабличнойЧасти.СтавкаНДС);
	Иначе
		СтрокаТабличнойЧасти.СтавкаНДС = Неопределено;
	КонецЕсли;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	РассчитатьСуммуВСтрокеТабличнойЧасти();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	РассчитатьСуммуВСтрокеТабличнойЧасти();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти.Количество <> 0 Тогда
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество;
	КонецЕсли;
	
	РассчитатьСуммуНДС(СтрокаТабличнойЧасти);
	РассчитатьСуммуВсегоВстрокеТЧ(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаНДСПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	РассчитатьСуммуВсегоВстрокеТЧ(СтрокаТабличнойЧасти);
КонецПроцедуры


&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуНДС(СтрокаТабличнойЧасти);
	РассчитатьСуммуВсегоВстрокеТЧ(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	РассчитатьСуммуДокумента();
	ОбновитьВсегоВТЧТовары();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	РассчитатьСуммуДокумента();
	ОбновитьВсегоВТЧТовары();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	уатОбщегоНазначенияКлиент.ТЧТоварыЕдиницаИзмеренияНачалоВыбора(Элементы.Товары.ТекущиеДанные.Номенклатура, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	//Если НЕ уатОбщегоНазначенияСервер.СуществуетСправочникЕдиницыИзмерения() 
	// ИЛИ СтрокаТабличнойЧасти.ЕдиницаИзмерения = ВыбранноеЗначение ИЛИ СтрокаТабличнойЧасти.Цена = 0 Тогда
	//	Возврат;
	//КонецЕсли;
	Если СтрокаТабличнойЧасти.ЕдиницаИзмерения = ВыбранноеЗначение
		ИЛИ СтрокаТабличнойЧасти.Цена = 0
		ИЛИ НЕ уатОбщегоНазначенияТиповые.уатЕстьРеквизитСправочника("Коэффициент", СтрокаТабличнойЧасти.ЕдиницаИзмерения) Тогда
		
		Возврат;
	КонецЕсли;	
	
	ТекКоэффициент = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(СтрокаТабличнойЧасти.ЕдиницаИзмерения,
																			"Коэффициент");
	Если ТекКоэффициент <> 0 Тогда
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Цена * уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(
									ВыбранноеЗначение, "Коэффициент") / ТекКоэффициент;
	КонецЕсли; 		
	
	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
	
	ТоварыСуммаПриИзменении(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		Если Объект.УчитыватьНДС Тогда
			Элементы.Товары.ТекущиеДанные.СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
				ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяСтавкаНДС");
		КонецЕсли;
	КонецЕсли;
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
Процедура ТоварыПодбор(Команда)
	ПараметрыПодбора = ПолучитьПараметрыПодбора("Товары");
	Если ПараметрыПодбора <> Неопределено Тогда
		уатОбщегоНазначенияТиповыеКлиент.уатОткрытьПодборНоменклатуры(ЭтотОбъект,ПараметрыПодбора,УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	Оповещ = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ПоказатьВводЗначения(Оповещ, "", "Введите штрихкод номенклатуры", Тип("Строка"));
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, ДопПараметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		ТекНоменклатура = уатЗащищенныеФункцииСервер_проф.ПолучитьОбъектПоШтрихкоду(Результат);
		ДобавитьНоменклатуруВТЧПоШтрихкоду(Новый Структура("Штрихкод, Объект", Результат, ТекНоменклатура));
	КонецЕсли;
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

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаХраненияОстатков);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

&НаКлиенте
Процедура ПриИзмененииКонтрагентаИлиОрганизации(Знач Оповещение)
	
	ДанныеОбменаССервером = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, УчитыватьНДС, Дата");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, Объект);
	// Получим данные с сервера
	ДанныеОбменаССервером.ДоговорКонтрагента = Объект.ДоговорКонтрагента;
	ЗначенияДляЗаполнения = ИзменениеКонтрагентаСервер(ДанныеОбменаССервером);
	Объект.ДоговорКонтрагента = ЗначенияДляЗаполнения.ДоговорКонтрагента;
	
	ДоговорПередИзменением = Договор;
	//Договор = Объект.ДоговорКонтрагента;
	
	Оповещ = Новый ОписаниеОповещения("ПриИзмененииКонтрагентаИлиОрганизацииЗавершение", ЭтотОбъект, Новый Структура("Оповещение", Оповещение));
	уатОбщегоНазначенияКлиент.ПриИзмененииДоговора(ЭтаФорма, Оповещ, ДоговорПередИзменением);

КонецПроцедуры

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

// Процедура выполняет пересчет в табличной части документа после изменений 
// в форме "Цены и валюта".Выполняется пересчет колонок: цена, скидка, сумма,
// сумма НДС, всего.
//
&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалюты(Знач Оповещение, Знач ВалютаРасчетовПередИзменением, ПересчитатьЦены = Ложь)
	
	// 1. Формируем структуру параметров для заполнения формы "Цены и Валюта".
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВалютаДокумента",		  Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("Курс",				  Объект.КурсВзаиморасчетов);
	СтруктураПараметров.Вставить("Кратность",			  Объект.КратностьВзаиморасчетов);
	СтруктураПараметров.Вставить("Контрагент",			  Объект.Контрагент);
	СтруктураПараметров.Вставить("Договор",				  Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("Организация",			  Объект.Организация);
	СтруктураПараметров.Вставить("ДатаДокумента",		  Объект.Дата);
	СтруктураПараметров.Вставить("ПерезаполнитьЦены",	  Ложь);
	СтруктураПараметров.Вставить("ПересчитатьЦены",		  ПересчитатьЦены);
	СтруктураПараметров.Вставить("БылиВнесеныИзменения",  Ложь);
	СтруктураПараметров.Вставить("СуммаВключаетНДС",      Объект.СуммаВключаетНДС);
	СтруктураПараметров.Вставить("НалогообложениеНДС",	  Объект.УчитыватьНДС);
	
	// Для объедининенного решения с БП 3
	СтруктураПараметров.Вставить("ДокументБезНДС",       НЕ Объект.УчитыватьНДС);
	СтруктураЦеныИВалюта = Неопределено;

	Если НЕ ПравоРедактированиеДокумента() Тогда
		СтруктураПараметров.Вставить("ТолькоПросмотр", Истина);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаЦеныИВалюта", СтруктураПараметров,,,,, Новый ОписаниеОповещения("ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение", ЭтотОбъект, Новый Структура("ВалютаРасчетовПередИзменением, Оповещение", ВалютаРасчетовПередИзменением, Оповещение)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена ИЛИ НЕ ПравоРедактированиеДокумента() Тогда
		Возврат;
	КонецЕсли;
	
    ВалютаРасчетовПередИзменением = ДополнительныеПараметры.ВалютаРасчетовПередИзменением;
    Оповещение = ДополнительныеПараметры.Оповещение;
        
    // Для объедининенного решения с БП 3
        
    // 2. Открываем форму "Цены и Валюта".
    СтруктураЦеныИВалюта = Результат;
    
    // 3. Перезаполняем табличную часть "Номенклатура", если были внесены изменения в форме "Цены и Валюта".
    Если ТипЗнч(СтруктураЦеныИВалюта) = Тип("Структура") Тогда
        
        // Для объедининенного решения с БП 3
        уатОбщегоНазначенияКлиент.ЗаполнитьСтруктуруЦеныИВалютыДляБП3(СтруктураЦеныИВалюта,Объект.ВалютаДокумента,ВалютаРасчетовПередИзменением,Объект.УчитыватьНДС,Объект.СуммаВключаетНДС);
        // Для объедининенного решения с БП 3
        Если СтруктураЦеныИВалюта.Свойство("ВалютаДокумента") И СтруктураЦеныИВалюта.Свойство("КурсРасчетов") И СтруктураЦеныИВалюта.Свойство("КратностьРасчетов") И
            СтруктураЦеныИВалюта.Свойство("СуммаВключаетНДС") И  СтруктураЦеныИВалюта.Свойство("НалогообложениеНДС") Тогда
            Объект.ВалютаДокумента		   = СтруктураЦеныИВалюта.ВалютаДокумента;
            Объект.КурсВзаиморасчетов	   = СтруктураЦеныИВалюта.Курс;
            Объект.КратностьВзаиморасчетов = СтруктураЦеныИВалюта.Кратность;
            Объект.СуммаВключаетНДС		   = СтруктураЦеныИВалюта.СуммаВключаетНДС;
            Объект.УчитыватьНДС			   = СтруктураЦеныИВалюта.НалогообложениеНДС;
        КонецЕсли;
        
        // Пересчитываем сумму если изменился признак Налогообложение НДС.
        Если СтруктураЦеныИВалюта.Свойство("НалогообложениеНДС") И СтруктураЦеныИВалюта.Свойство("ПредНалогообложениеНДС") Тогда
            Если СтруктураЦеныИВалюта.НалогообложениеНДС <> СтруктураЦеныИВалюта.ПредНалогообложениеНДС Тогда
                ЗаполнитьСтавкуНДСПоНалогообложениеНДС();
            КонецЕсли;
        КонецЕсли;
        
        // Пересчитываем цены по валюте.
        Если СтруктураЦеныИВалюта.Свойство("ПересчитатьЦены") Тогда
            Если СтруктураЦеныИВалюта.ПересчитатьЦены Тогда	
                ПересчитатьЦеныТабличнойЧастиПоВалюте(ВалютаРасчетовПередИзменением, "Товары");
            КонецЕсли;
        КонецЕсли;
        
        // Пересчитываем сумму если изменился признак "Сумма включает НДС".
        Если СтруктураЦеныИВалюта.Свойство("СуммаВключаетНДС") И СтруктураЦеныИВалюта.Свойство("ПредСуммаВключаетНДС") Тогда
            Если СтруктураЦеныИВалюта.СуммаВключаетНДС <> СтруктураЦеныИВалюта.ПредСуммаВключаетНДС Тогда
                ПересчитатьСуммуТабличнойЧастиПоФлагуСуммаВключаетНДС("Товары");
            КонецЕсли;
        КонецЕсли;
    КонецЕсли;
	
	ОбновитьВсегоВТЧТовары();
	ВывестиСуммовыеИтогиДокумента();
	
	Если Не Оповещение = Неопределено Тогда 
		ВыполнитьОбработкуОповещения(Оповещение);
	КонецЕсли;

КонецПроцедуры // ОбработатьИзмененияПоКнопкеЦеныИВалюты()

// Процедура заполняет Ставку НДС в табличной части по системе налогообложения.
// 
&НаСервере
Процедура ЗаполнитьСтавкуНДСПоНалогообложениеНДС()
	
	//СтавкаНДСПоУмолчанию = уатОбщегоНазначенияПовтИсп.ПолучитьСтавкуНДСНоль();
	СтавкаНДСПоУмолчанию = Перечисления.СтавкиНДС.ПустаяСсылка();
	Для каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл
		Если СтрокаТабличнойЧасти.СтавкаНДС <> СтавкаНДСПоУмолчанию Тогда
			СтрокаТабличнойЧасти.СтавкаНДС = СтавкаНДСПоУмолчанию;
			СтрокаТабличнойЧасти.СуммаНДС = 0;
		КонецЕсли;
	КонецЦикла;
		
	Если Объект.УчитыватьНДС Тогда
		
		Элементы.ТоварыСтавкаНДС.Видимость = Истина;
		Элементы.ТоварыСуммаНДС.Видимость = Истина;
		Элементы.ТоварыВсего.Видимость = Истина;
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура.СтавкаНДС) Тогда
				СтрокаТабличнойЧасти.СтавкаНДС = СтрокаТабличнойЧасти.Номенклатура.СтавкаНДС;
			КонецЕсли;	
			
			СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
			СтрокаТабличнойЧасти.СуммаНДС = ?(Объект.СуммаВключаетНДС, 
									  		СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДС + 100) / 100),
									  		СтрокаТабличнойЧасти.Сумма * СтавкаНДС / 100);
		КонецЦикла;
										
	Иначе
		
		Элементы.ТоварыСтавкаНДС.Видимость = Ложь;
		Элементы.ТоварыСуммаНДС.Видимость = Ложь;
		Элементы.ТоварыВсего.Видимость = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры // ЗаполнитьСтавкуНДСПоНалогообложениеНДС()

&НаКлиенте
Процедура РедактироватьЦеныИВалюту(Команда)
	
	ОбработатьИзмененияПоКнопкеЦеныИВалюты(Новый ОписаниеОповещения("РедактироватьЦеныИВалютуЗавершение", ЭтотОбъект), Объект.ВалютаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЦеныИВалютуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    РассчитатьСуммуДокумента();
    ОбновитьВсегоВТЧТовары();
    Модифицированность = Истина;

КонецПроцедуры

// Процедура рассчитывает сумму в строке табличной части.
//
&НаКлиенте
Процедура РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти = Неопределено)
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
	
	РассчитатьСуммуНДС(СтрокаТабличнойЧасти);
	РассчитатьСуммуВсегоВстрокеТЧ(СтрокаТабличнойЧасти);
	
КонецПроцедуры // РассчитатьСуммуВСтрокеТабличнойЧасти()

// Рассчитывается сумма НДС в строке табличной части.
//
&НаКлиенте
Процедура РассчитатьСуммуНДС(СтрокаТабличнойЧасти)
	
	СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
	
	СтрокаТабличнойЧасти.СуммаНДС = ?(Объект.СуммаВключаетНДС, 
									  СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДС + 100) / 100),
									  СтрокаТабличнойЧасти.Сумма * СтавкаНДС / 100);
	
КонецПроцедуры // РассчитатьСуммуНДС()

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");
	Если Объект.УчитыватьНДС И НЕ Объект.СуммаВключаетНДС Тогда
		Объект.СуммаДокумента = Объект.СуммаДокумента + Объект.Товары.Итог("СуммаНДС");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуВсегоВстрокеТЧ(СтрокаТабличнойЧасти)
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма
		+ ?(Объект.УчитыватьНДС И НЕ Объект.СуммаВключаетНДС, СтрокаТабличнойЧасти.СуммаНДС, 0);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВсегоВТЧТовары()
	Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл
		РассчитатьСуммуВсегоВстрокеТЧ(СтрокаТабличнойЧасти);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбновитьВсегоВТЧСервер()
	Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл
		СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма
			+ ?(Объект.УчитыватьНДС И НЕ Объект.СуммаВключаетНДС, СтрокаТабличнойЧасти.СуммаНДС, 0);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПересчитататьНДС()
	ПересчитатьСуммуТабличнойЧастиПоФлагуСуммаВключаетНДС("Товары");
	РассчитатьСуммуДокумента();
	ОбновитьВсегоВТЧТовары();
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ДатаРасчетов 	 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	
	ЗаголовокПодбора = НСтр("en='Selection products and services in %1 (%2)';ru='Подбор номенклатуры в %1 (%2)'");
	ПредставлениеТаблицы = НСтр("en='Goods';ru='Товары'");
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, НСтр("en='Goods';ru='Товары'"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьЦены", Истина);
	ПараметрыФормы.Вставить("ЕстьЦена"      , Истина);
	ПараметрыФормы.Вставить("Контрагент"    , Объект.Контрагент);
	ПараметрыФормы.Вставить("ЕстьКоличество", Истина);
	ПараметрыФормы.Вставить("ДатаРасчетов"  , ДатаРасчетов);
	ПараметрыФормы.Вставить("Валюта"        , Объект.ВалютаДокумента);
	ПараметрыФормы.Вставить("Склад"         , Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок"     , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"    , ПолучитьВидПодбора(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"    , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"        , ИмяТаблицы = "Услуги");
	ПараметрыФормы.Вставить("Организация"   , Объект.Организация);
	ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
	ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);
	
	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьВидПодбора(ИмяТаблицы)

	ВидПодбора = "";
	
	Возврат ВидПодбора;

КонецФункции

&НаСервере 
Функция ПолучитьТоварыИзВременногоХранилища(ЗначениеВыбора)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ЗначениеВыбора);
	МассивТоваров = Новый Массив;
	Для Каждого ТекСтрока Из ТаблицаТоваров Цикл
		Структура = Новый Структура;
		Структура.Вставить("Номенклатура",ТекСтрока.Номенклатура);
		Структура.Вставить("ЕдиницаИзмерения", ТекСтрока.Номенклатура.ЕдиницаХраненияОстатков);
		Структура.Вставить("Количество",ТекСтрока.Количество);
		Структура.Вставить("Цена",ТекСтрока.Цена);
		МассивТоваров.Добавить(Структура);
	КонецЦикла;
	
	Возврат МассивТоваров;
КонецФункции

// Производит заполнение документа переданными из формы подбора данными.
//
// Параметры:
//  ТабличнаяЧасть    - табличная часть, в которую надо добавлять подобранную позицию номенклатуры;
//  ЗначениеВыбора    - структура, содержащая параметры подбора.
//
&НаКлиенте
Процедура ОбработкаПодбора(ИмяТабличнойЧасти, ЗначениеВыбора)

	Если ЗначениеВыбора.Свойство("АдресПодобраннойНоменклатурыВХранилище") Тогда
		МассивТоваров = ПолучитьТоварыИзВременногоХранилища(ЗначениеВыбора.АдресПодобраннойНоменклатурыВХранилище);
	Иначе
		МассивТоваров = ПолучитьТоварыИзВременногоХранилища(ЗначениеВыбора.АдресТоваровВХранилище);
	КонецЕсли;

	Для Каждого ТекСтрока из МассивТоваров Цикл
		
		// Ищем выбранную позицию в таблице подобранной номенклатуры.
		// Если найдем - увеличим количество; не найдем - добавим новую строку.
		СтруктураОтбора = Новый Структура();
		
		СтруктураОтбора.Вставить("Номенклатура",     ТекСтрока.Номенклатура);
		СтруктураОтбора.Вставить("ЕдиницаИзмерения", ТекСтрока.ЕдиницаИзмерения);
		СтруктураОтбора.Вставить("Цена",             ТекСтрока.Цена);

		
		МассивСтрок = Объект.Товары.НайтиСтроки(СтруктураОтбора);
		Если МассивСтрок.Количество() = 0 Тогда
			СтрокаТабличнойЧасти = Неопределено;
		Иначе
			СтрокаТабличнойЧасти = МассивСтрок[0];
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			// Нашли, увеличиваем количество в первой найденной строке.
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество +   ТекСтрока.Количество;
		Иначе
			// Не нашли - добавляем новую строку.
			СтрокаТабличнойЧасти = Объект.Товары.Добавить();
			СтрокаТабличнойЧасти.Номенклатура	  = ТекСтрока.Номенклатура;
			СтрокаТабличнойЧасти.Количество  	  = ТекСтрока.Количество;
			СтрокаТабличнойЧасти.ЕдиницаИзмерения =  ТекСтрока.ЕдиницаИзмерения;
			
			СтрокаТабличнойЧасти.Цена = ТекСтрока.Цена;
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена) Тогда
				ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти);
			КонецЕсли;
			
			Если Объект.УчитыватьНДС Тогда
				СтрокаТабличнойЧасти.СтавкаНДС = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТекСтрока.Номенклатура,
				"СтавкаНДС");
			КонецЕсли;
		КонецЕсли;
		РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
	КонецЦикла;
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры //

&НаКлиенте
Процедура УстановитьВидимость()

	// Колонки налога показываем только тогда, когда его учитываем.
	Если Элементы.ТоварыСтавкаНДС.Видимость <> Объект.УчитыватьНДС Тогда
		Элементы.ТоварыСтавкаНДС.Видимость = Объект.УчитыватьНДС;
	КонецЕсли;
	Если Элементы.ТоварыСуммаНДС.Видимость <> Объект.УчитыватьНДС Тогда
		Элементы.ТоварыСуммаНДС.Видимость = Объект.УчитыватьНДС;
	КонецЕсли;
	Если Элементы.ТоварыВсего.Видимость <> Объект.УчитыватьНДС Тогда
		Элементы.ТоварыВсего.Видимость = Объект.УчитыватьНДС;
	КонецЕсли;
	
	ВывестиСуммовыеИтогиДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ВывестиСуммовыеИтогиДокумента()
	
	Если Объект.УчитыватьНДС Тогда 
		Если Объект.СуммаВключаетНДС Тогда 
			НадписьВсегоНДС = НСтр("en='VAT amount';ru='НДС в сумме'") + ":";
		Иначе 
			НадписьВсегоНДС = НСтр("en='VAT from above';ru='НДС сверху'") + ":";
		КонецЕсли;
		НадписьВсего = НСтр("en='Total including VAT';ru='Всего с НДС'");
		Элементы.СтраницыИтогов.ТекущаяСтраница = Элементы.ИтогоУчетНДС;
	Иначе 
		НадписьВсего = НСтр("en='Total';ru='Всего'");
		Элементы.СтраницыИтогов.ТекущаяСтраница = Элементы.ИтогоБезНДС;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ВалютаДокумента) Или Объект.ВалютаДокумента = мВалютаРегламентированногоУчета Тогда 
		НадписьКурс = "(1.0000)";
		Элементы.НадписьКурс.Видимость = Ложь;
		Элементы.НадписьКурс2.Видимость = Ложь;
	Иначе 
		НадписьКурс = "(" + Формат(Объект.КурсВзаиморасчетов, "ЧДЦ=4; ЧРД=.; ЧН=0.0000; ЧГ=0") + ")";
		Элементы.НадписьКурс.Видимость = Истина;
		Элементы.НадписьКурс2.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПравоРедактированиеДокумента()
	Рез = ПравоДоступа("Редактирование", Метаданные.Документы.уатВозвратТоваров);
	Возврат Рез;
КонецФункции

&НаСервере
Процедура ПересчитатьСуммуТабличнойЧастиПоФлагуСуммаВключаетНДС(ИмяТЧ)
	уатОбщегоНазначенияСервер.ПересчитатьСуммуТабличнойЧастиПоФлагуСуммаВключаетНДС(Объект[ИмяТЧ], Объект.СуммаВключаетНДС);
КонецПроцедуры

&НаСервере
Процедура ПересчитатьЦеныТабличнойЧастиПоВалюте(ВалютаРасчетовПередИзменением, ИмяТЧ)
	уатОбщегоНазначенияСервер.ПересчитатьЦеныТабличнойЧастиПоВалюте(Объект, ВалютаРасчетовПередИзменением, ИмяТЧ);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти)
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) Тогда
		Если Объект.УчитыватьНДС Тогда
			СтавкаНДС = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(
				СтрокаТабличнойЧасти.Номенклатура, "СтавкаНДС");
			СтрокаТабличнойЧасти.СтавкаНДС = ?(ЗначениеЗаполнено(СтавкаНДС), СтавкаНДС, СтрокаТабличнойЧасти.СтавкаНДС);
		Иначе
			СтрокаТабличнойЧасти.СтавкаНДС = Неопределено;
		КонецЕсли;
				
		СтруктураЦенаВалюта = уатОбщегоНазначения.уатНайтиЦенуНоменклатуры(Объект.Дата, СтрокаТабличнойЧасти.Номенклатура, Объект.Контрагент, Ложь);
		мЦена = 0;
		Если ЗначениеЗаполнено(СтруктураЦенаВалюта.Цена) Тогда
			мЦена = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(СтруктураЦенаВалюта.Цена,
				СтруктураЦенаВалюта.Валюта, Объект.ВалютаДокумента,
				Объект.Дата, Объект.Дата);
		КонецЕсли;
		СтрокаТабличнойЧасти.Цена = мЦена;
		
		РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНоменклатуруВТЧПоШтрихкоду(Результат, ДопПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено ИЛИ НЕ ЗначениеЗаполнено(Результат.Объект)
		ИЛИ ТипЗнч(Результат.Объект) <> Тип("СправочникСсылка.Номенклатура") Тогда
		Возврат;
	КонецЕсли;
	Номенклатура = Результат.Объект;
	
	// Ищем выбранную позицию в таблице подобранной номенклатуры.
	// Если найдем - увеличим количество; не найдем - добавим новую строку.
	МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура", Номенклатура));
	Если МассивСтрок.Количество() = 0 Тогда
		СтрокаТабличнойЧасти = Неопределено;
	Иначе
		СтрокаТабличнойЧасти = МассивСтрок[0];
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		// Нашли, увеличиваем количество в первой найденной строке.
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + 1;
	Иначе
		// Не нашли - добавляем новую строку.
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();
		СтрокаТабличнойЧасти.Номенклатура = Номенклатура;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(
			СтрокаТабличнойЧасти.Номенклатура, "ЕдиницаХраненияОстатков");
		СтрокаТабличнойЧасти.Количество = 1;
		ЗаполнитьЦенуПоКонтрагенту(СтрокаТабличнойЧасти);
		
		Если Объект.УчитыватьНДС Тогда 
			СтрокаТабличнойЧасти.СтавкаНДС = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(
				СтрокаТабличнойЧасти.Номенклатура, "СтавкаНДС");
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС) Тогда
				СтрокаТабличнойЧасти.СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
				ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяСтавкаНДС");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
	ОбновитьВсегоВТЧТовары();
	
КонецПроцедуры

#КонецОбласти
