
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
	
	// Установка реквизитов формы.
	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		Объект.ВидОперации = Перечисления.уатВидыДокументаИнвентаризацияАгрегатов.ИнвентаризацияНаСкладах;
	КонецЕсли;
	
	уатОбщегоНазначенияСервер.НастроитьПолеПодразделение(Элементы.Подразделение, "Объект.Организация");
	
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
	
	// Установить видимость реквизитов и заголовков колонок.
	УстановитьВидимость();
	
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
Процедура ВидОперацииПриИзменении(Элемент)
	Если Объект.ВидОперации = ПредопределенноеЗначение(
				"Перечисление.уатВидыДокументаИнвентаризацияАгрегатов.ИнвентаризацияНаТС") Тогда
		Объект.Склад = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
		Объект.АгрегатыСклад.Очистить();
	Иначе
		Объект.АгрегатыТС.Очистить();
	КонецЕсли;	
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_АгрегатыТС

&НаКлиенте
Процедура АгрегатыТСТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	уатИнтерфейсВводаТС.РеквизитТСНачалоВыбора(Элемент, Элементы.АгрегатыТС.ТекущиеДанные.ТС, ДанныеВыбора, СтандартнаяОбработка, СтруктураОтбор);
КонецПроцедуры

&НаКлиенте
Процедура АгрегатыТСТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	уатИнтерфейсВводаТС.РеквизитТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка, СтруктураОтбор);
КонецПроцедуры

&НаКлиенте
Процедура АгрегатыТСТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	уатИнтерфейсВводаТС.РеквизитТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка, СтруктураОтбор);
КонецПроцедуры

&НаКлиенте
Процедура АгрегатыСкладАгрегатПриИзменении(Элемент)
	ТекСтрока = Элементы.АгрегатыСклад.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекСтрока.Агрегат) Тогда
		ТекСтрока.МОЛ = ПолучитьМОЛДляАгрегата(ТекСтрока.Агрегат,Истина);
	Иначе
		ТекСтрока.МОЛ = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АгрегатыТСАгрегатПриИзменении(Элемент)
	ТекСтрока = Элементы.АгрегатыТС.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекСтрока.Агрегат)  Тогда
		ТекСтрока.МОЛ = ПолучитьМОЛДляАгрегата(ТекСтрока.Агрегат,Ложь)
	Иначе
		ТекСтрока.МОЛ = Неопределено;
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

&НаКлиенте
Процедура СкладОчистить(Команда)
	Если Объект.АгрегатыСклад.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстНСТР = НСтр("en='Clear the tabular section?';ru='Очистить табличную часть?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("СкладОчиститьЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет, "Очистка таблицы");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиСклад(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
		ТекстНСТР = НСтр("en='Select warehouse.';ru='Необходимо выбрать склад.'");
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР);
		Возврат;
	КонецЕсли;
	
	Если Объект.АгрегатыСклад.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Before filling the datasheet portion will be cleared. Fill?';ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьОстаткамиСкладЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОстаткамиСкладФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиСкладУчетные(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
		ТекстНСТР = НСтр("en='Select warehouse.';ru='Необходимо выбрать склад.'");
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР);
		Возврат;
	КонецЕсли;
	
	Если Объект.АгрегатыСклад.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Before filling the datasheet portion will be cleared. Fill?';ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьОстаткамиСкладУчетныеЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
        Возврат;
	КонецЕсли;
	
	ЗаполнитьОстаткамиСкладУчетныеФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ТСОчистить(Команда)
	Если Объект.АгрегатыТС.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстНСТР = НСтр("en='Clear the tabular section?';ru='Очистить табличную часть?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ТСОчиститьЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНет,,	КодВозвратаДиалога.Нет, "Очистка таблицы");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиТС(Команда)
	Если Объект.АгрегатыТС.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Before filling the datasheet portion will be cleared. Fill?';ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьОстаткамиТСЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
        Возврат;
	КонецЕсли;
	
	ЗаполнитьОстаткамиТСФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиТСУчетные(Команда)
	Если Объект.АгрегатыТС.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Before filling the datasheet portion will be cleared. Fill?';ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьОстаткамиТСУчетныеЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
        Возврат;
	КонецЕсли;
	
	ЗаполнитьОстаткамиТСУчетныеФрагмент();
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

&НаСервере
Процедура ЗаполнитьПоОстаткамНаСкладеСервер(ТолькоУчетные = Ложь)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатОстаткиАгрегатовОстатки.СерияНоменклатуры КАК Агрегат,
	|	уатОстаткиАгрегатовОстатки.МОЛ
	|ИЗ
	|	РегистрНакопления.уатОстаткиАгрегатов.Остатки(&ДатаОстатков, Склад = &Склад) КАК уатОстаткиАгрегатовОстатки
	|УПОРЯДОЧИТЬ ПО
	|	уатОстаткиАгрегатовОстатки.СерияНоменклатуры.Наименование";
	
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("ДатаОстатков", ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаТабличнойЧасти = Объект.АгрегатыСклад.Добавить();
		
		СтрокаТабличнойЧасти.Агрегат       = Выборка.Агрегат;
		СтрокаТабличнойЧасти.МОЛ           = Выборка.МОЛ;
		СтрокаТабличнойЧасти.НаличиеУчет   = Истина;
		СтрокаТабличнойЧасти.Наличие       = ?(ТолькоУчетные, Ложь, Истина);
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамНаТССервер(РезультатЗакрытия, ДопПараметры)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТС",           РезультатЗакрытия);
	Запрос.УстановитьПараметр("ДатаОстатков", ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатАгрегатыТССрезПоследних.СерияНоменклатуры КАК Агрегат,
	|	уатАгрегатыТССрезПоследних.ТС КАК ТС,
	|	уатАгрегатыТССрезПоследних.МОЛ КАК МОЛ
	|ИЗ
	|	РегистрСведений.уатАгрегатыТС.СрезПоследних(&ДатаОстатков, ТС В (&ТС)) КАК уатАгрегатыТССрезПоследних
	|ГДЕ
	|	(уатАгрегатыТССрезПоследних.СостояниеАгрегата = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВРаботе)
	|			ИЛИ уатАгрегатыТССрезПоследних.СостояниеАгрегата = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВЗапас))
	|
	|УПОРЯДОЧИТЬ ПО
	|	уатАгрегатыТССрезПоследних.СерияНоменклатуры.Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТабличнойЧасти = Объект.АгрегатыТС.Добавить();
		СтрокаТабличнойЧасти.Агрегат     = Выборка.Агрегат;
		СтрокаТабличнойЧасти.ТС          = Выборка.ТС;
		СтрокаТабличнойЧасти.МОЛ         = Выборка.МОЛ;
		СтрокаТабличнойЧасти.НаличиеУчет = Истина;
		СтрокаТабличнойЧасти.Наличие     = ?(ДопПараметры.ТолькоУчетные, Ложь, Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМОЛДляАгрегата(Агрегат,НаСкладе);
	Запрос = Новый Запрос;
	Если НаСкладе Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатОстаткиАгрегатовОстатки.МОЛ
		|ИЗ
		|	РегистрНакопления.уатОстаткиАгрегатов.Остатки(&Дата, СерияНоменклатуры = &Агрегат) КАК уатОстаткиАгрегатовОстатки
		|ГДЕ
		|	уатОстаткиАгрегатовОстатки.КоличествоОстаток > 0";
		
	Иначе
		// Агрегат на ТС
		Запрос.Текст =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатАгрегатыТССрезПоследних.МОЛ
		|ИЗ
		|	РегистрСведений.уатАгрегатыТС.СрезПоследних(
		|			&Дата,
		|			СерияНоменклатуры = &Агрегат
		|				И СостояниеАгрегата = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВРаботе)) КАК уатАгрегатыТССрезПоследних";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Запрос.УстановитьПараметр("Дата",КонецДня(Объект.Дата));
	Иначе
		Запрос.УстановитьПараметр("Дата",Объект.Дата);
	КонецЕсли;
	Запрос.УстановитьПараметр("Агрегат",Агрегат);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.МОЛ;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура УстановитьВидимость()
	ЗначениеВидимости = (Объект.ВидОперации = ПредопределенноеЗначение(
							"Перечисление.уатВидыДокументаИнвентаризацияАгрегатов.ИнвентаризацияНаСкладах"));
	Элементы.Склад.Видимость 		 = ЗначениеВидимости;
	Элементы.АгрегатыСклад.Видимость = ЗначениеВидимости;
	Элементы.АгрегатыТС.Видимость 	 = НЕ ЗначениеВидимости; 
КонецПроцедуры

&НаКлиенте
Процедура СкладОчиститьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        Объект.АгрегатыСклад.Очистить();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиСкладЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    Объект.АгрегатыСклад.Очистить();
    
    ЗаполнитьОстаткамиСкладФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиСкладФрагмент()
	
	ЗаполнитьПоОстаткамНаСкладеСервер();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиСкладУчетныеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли; 
	
	Объект.АгрегатыСклад.Очистить();
	
	ЗаполнитьОстаткамиСкладУчетныеФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиСкладУчетныеФрагмент()
	
	ЗаполнитьПоОстаткамНаСкладеСервер(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ТСОчиститьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        Объект.АгрегатыТС.Очистить();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиТСЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    Объект.АгрегатыТС.Очистить();
    
    ЗаполнитьОстаткамиТСФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиТСФрагмент()
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИсточникПодбора", "Документ_уатИнвентаризацияАгрегатов");
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения(
		"ЗаполнитьОстаткамиТСЗаполнение", 
		ЭтотОбъект, 
		Новый Структура("ТолькоУчетные", Ложь)
	);
	
	ОткрытьФорму(
		"ОбщаяФорма.уатФормаПодбораТС", 
		ПараметрыФормы, 
		ЭтотОбъект,
		,
		,
		,
		ОповещениеОЗакрытии, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиТСЗаполнение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПоОстаткамНаТССервер(РезультатЗакрытия, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиТСУчетныеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    Объект.АгрегатыТС.Очистить();
    
    ЗаполнитьОстаткамиТСУчетныеФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиТСУчетныеФрагмент()
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИсточникПодбора", "Документ_уатИнвентаризацияАгрегатов");
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения(
		"ЗаполнитьОстаткамиТСУчетныеЗаполнение", 
		ЭтотОбъект, 
		Новый Структура("ТолькоУчетные", Истина)
	);
	
	ОткрытьФорму(
		"ОбщаяФорма.уатФормаПодбораТС", 
		ПараметрыФормы, 
		ЭтотОбъект,
		,
		,
		,
		ОповещениеОЗакрытии, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиТСУчетныеЗаполнение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПоОстаткамНаТССервер(РезультатЗакрытия, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти
