
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаказГрузоотправителя = Неопределено;
	ТекМаршрутныйЛист     = Неопределено;
	
	ПодборВАктОтгрузки      = Ложь;
	ПодборВАктПриемки       = Ложь;
	ПодборВОперациюСГрузом  = Ложь;
	МаршрутныйЛистДляОтбора = Неопределено;
	СкладДляОтбора          = Неопределено;
	ТекущийАктОтгрузки      = Неопределено;
	ТекущийАктПриемки       = Неопределено;
	ТекущаяОперацияСГрузом  = Неопределено;
	
	ТабПодобранныхГрузов = Новый ТаблицаЗначений();
	ТабПодобранныхГрузов.Колонки.Добавить("Груз",             Новый ОписаниеТипов("СправочникСсылка.Номенклатура, СправочникСсылка.уатГрузовыеМеста_уэ"));
	ТабПодобранныхГрузов.Колонки.Добавить("ЕдиницаИзмерения", Новый ОписаниеТипов("СправочникСсылка.уатТипыКонтейнеров_уэ, СправочникСсылка.уатВидыУпаковки_уэ, СправочникСсылка.ЕдиницыИзмерения"));
	ТабПодобранныхГрузов.Колонки.Добавить("Количество",       Новый ОписаниеТипов("Число"));
	
	Параметры.Свойство("ЗаказКРазмещению",        ЗаказГрузоотправителя);
	Параметры.Свойство("ТекущийМЛ",               ТекМаршрутныйЛист);
	Параметры.Свойство("ПодборВМаршрутныйЛист",   ПодборВМаршрутныйЛист);
	Параметры.Свойство("ПодборВЗаказПеревозчику", ПодборВЗаказПеревозчику);
	
	Параметры.Свойство("ПодборВАктОтгрузки",      ПодборВАктОтгрузки);
	Параметры.Свойство("ПодборВАктПриемки",       ПодборВАктПриемки);
	Параметры.Свойство("МаршрутныйЛистДляОтбора", МаршрутныйЛистДляОтбора);
	Параметры.Свойство("СкладДляОтбора",          СкладДляОтбора);
	Параметры.Свойство("ТекущийАктОтгрузки",      ТекущийАктОтгрузки);
	Параметры.Свойство("ТекущийАктПриемки",       ТекущийАктПриемки);
	
	Параметры.Свойство("ПодборВОперациюСГрузом", ПодборВОперациюСГрузом);
	Параметры.Свойство("ТекущаяОперацияСГрузом", ТекущаяОперацияСГрузом);
	
	Если ЗначениеЗаполнено(ЗаказГрузоотправителя) Тогда
		флГрузыFTL = ЗаказГрузоотправителя.FTL
			И ЗаказГрузоотправителя.ДетализацияЗакрытия <> Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоЗаказам
	КонецЕсли;
	
	Если Параметры.Свойство("РазмещенныеГрузы") Тогда 
		Для Каждого ТекСтрока Из Параметры.РазмещенныеГрузы Цикл 
			НайдСтроки = ТабПодобранныхГрузов.НайтиСтроки(Новый Структура("Груз, ЕдиницаИзмерения", ТекСтрока.Груз, ТекСтрока.ЕдиницаИзмерения));
			Если НайдСтроки.Количество() = 0 Тогда 
				НовСтрока = ТабПодобранныхГрузов.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрока);
			Иначе 
				НайдСтроки[0].Количество = НайдСтроки[0].Количество + ТекСтрока.Количество;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ЗаполнитьСписокГрузовПоОстаткам(
		ЗаказГрузоотправителя, 
		ТекМаршрутныйЛист, 
		ТабПодобранныхГрузов, 
		ПодборВАктОтгрузки,
		ПодборВАктПриемки,
		МаршрутныйЛистДляОтбора,
		СкладДляОтбора, 
		ТекущийАктОтгрузки,
		ТекущийАктПриемки,
		ПодборВОперациюСГрузом,
		ТекущаяОперацияСГрузом
	);
	
	ПредставлениеЕдиницыИзмеренияВеса = уатОбщегоНазначенияПовтИсп.ПолучитьПредставлениеОсновнойЕдиницыИзмеренияВеса();
	Если ЗначениеЗаполнено(ПредставлениеЕдиницыИзмеренияВеса) Тогда
		Элементы.ТаблицаГрузовВесБрутто.Заголовок        = НСтр("en='Weight';ru='Вес'") + ", " + ПредставлениеЕдиницыИзмеренияВеса;
		Элементы.ТаблицаГрузовВесБруттоОстаток.Заголовок = НСтр("en='Remain';ru='Остаток'")+ ", " + ПредставлениеЕдиницыИзмеренияВеса;
	КонецЕсли;
	
	ПредставлениеЕдиницыИзмеренияОбъема = уатОбщегоНазначенияПовтИсп.ПолучитьПредставлениеОсновнойЕдиницыИзмеренияОбъема();
	Если ЗначениеЗаполнено(ПредставлениеЕдиницыИзмеренияОбъема) Тогда
		Элементы.ТаблицаГрузовОбъем.Заголовок        = НСтр("en='Volume';ru='Объем'") + ", " + ПредставлениеЕдиницыИзмеренияОбъема;
		Элементы.ТаблицаГрузовОбъемОстаток.Заголовок = НСтр("en='Remain';ru='Остаток'")+ ", " + ПредставлениеЕдиницыИзмеренияОбъема;
	КонецЕсли;
	
	ПредставлениеОсновнойВидУпаковки = Строка(Справочники.уатВидыУпаковки_уэ.ПолучитьОсновнойВидУпаковки());
	Если ЗначениеЗаполнено(ПредставлениеОсновнойВидУпаковки) Тогда 
		Элементы.ТаблицаГрузовКоличествоМест.Заголовок = Справочники.уатВидыУпаковки_уэ.ПолучитьОсновнойВидУпаковки().КраткоеНаименование;
		Элементы.ТаблицаГрузовКоличествоМестОстаток.Заголовок = НСтр("en='Remain';ru='Остаток'") + " (" + ПредставлениеОсновнойВидУпаковки + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ТаблицаГрузов

&НаКлиенте
Процедура ТаблицаГрузовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если флГрузыFTL Тогда
		ПодобратьГрузы(Элементы.ТаблицаГрузовПодобратьГрузы);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ТаблицаГрузовКоличество Или Поле = Элементы.ТаблицаГрузовВыборСтрок Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ТекущиеДанные.КоличествоПодбор = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ПодобранныеГрузы = Новый Массив();
	
	ДанныеСтроки = Новый Структура();
	ДанныеСтроки.Вставить("Груз",             ТекущиеДанные.Груз);
	ДанныеСтроки.Вставить("Количество",       ТекущиеДанные.КоличествоПодбор);
	ДанныеСтроки.Вставить("ЕдиницаИзмерения", ТекущиеДанные.ЕдиницаИзмерения);
	ДанныеСтроки.Вставить("ВесБрутто",        ТекущиеДанные.ВесБруттоПодбор);
	ДанныеСтроки.Вставить("Объем",            ТекущиеДанные.ОбъемПодбор);
	ДанныеСтроки.Вставить("КоличествоМест",   ТекущиеДанные.КоличествоМестПодбор);
	
	ПодобранныеГрузы.Добавить(ДанныеСтроки);
	
	Закрыть(ПодобранныеГрузы);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаГрузовКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаГрузов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.КоличествоПодбор > ТекущиеДанные.КоличествоОстаток Тогда 
		ТекущиеДанные.КоличествоПодбор = ТекущиеДанные.КоличествоОстаток;
	КонецЕсли;
	ТекущиеДанные.ВыборСтрок = ТекущиеДанные.КоличествоОстаток > 0;
	
	ЗаполнитьВОХВСтроке(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаГрузовВыборСтрокПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаГрузов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ВыборСтрок Тогда
		ТекущиеДанные.КоличествоПодбор = ТекущиеДанные.КоличествоОстаток;
	Иначе
		ТекущиеДанные.КоличествоПодбор = 0;
	КонецЕсли;
	
	ЗаполнитьВОХВСтроке(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьГрузы(Команда)
	
	ПодобранныеГрузы = Новый Массив();
	Для Каждого ТекСтрока Из ТаблицаГрузов Цикл 
		Если ТекСтрока.КоличествоПодбор = 0 Тогда 
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Новый Структура();
		ДанныеСтроки.Вставить("Груз",             ТекСтрока.Груз);
		ДанныеСтроки.Вставить("Количество",       ТекСтрока.КоличествоПодбор);
		ДанныеСтроки.Вставить("ЕдиницаИзмерения", ТекСтрока.ЕдиницаИзмерения);
		ДанныеСтроки.Вставить("ВесБрутто",        ТекСтрока.ВесБруттоПодбор);
		ДанныеСтроки.Вставить("Объем",            ТекСтрока.ОбъемПодбор);
		ДанныеСтроки.Вставить("КоличествоМест",   ТекСтрока.КоличествоМестПодбор);
		
		// Для подбора FTL заказов в МЛ целиком
		ДанныеСтроки.Вставить("НомерСтрокиГруза", ТекСтрока.НомерСтрокиГруза);
				
		ПодобранныеГрузы.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	Закрыть(ПодобранныеГрузы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеГрузы(Команда)
	
	Для Каждого ТекСтрока Из ТаблицаГрузов Цикл 
		ТекСтрока.КоличествоПодбор = ТекСтрока.КоличествоОстаток;
		ТекСтрока.ВыборСтрок = Истина;
		ЗаполнитьВОХВСтроке(ТекСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеГрузы(Команда)
	
	Для Каждого ТекСтрока Из ТаблицаГрузов Цикл 
		ТекСтрока.КоличествоПодбор = 0;
		ТекСтрока.ВыборСтрок = Ложь;
		ЗаполнитьВОХВСтроке(ТекСтрока);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	
	Элементы.ТаблицаГрузовГруппаУстановкаОтметок.Доступность = Не флГрузыFTL;
	Элементы.ПодсказкаFTLЗаказ.Видимость = флГрузыFTL;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокГрузовПоОстаткам(ЗаказГрузоотправителя, ТекМаршрутныйЛист, ТабПодобранныхГрузов, 
		ПодборВАктОтгрузки, ПодборВАктПриемки, МаршрутныйЛистДляОтбора, СкладДляОтбора,
		ТекущийАктОтгрузки, ТекущийАктПриемки, ПодборВОперациюСГрузом, ТекущаяОперацияСГрузом)
	
	Если ПодборВАктОтгрузки Тогда 
		ТабГрузов = уатОбщегоНазначенияСервер.ПолучитьСписокГрузовПоОстаткамКРазмещениюДляПодбора(
			ЗаказГрузоотправителя, 
			СкладДляОтбора, 
			ТекущийАктОтгрузки,
			ТабПодобранныхГрузов
		);
	ИначеЕсли ПодборВОперациюСГрузом Тогда
		ТабГрузов = уатОбщегоНазначенияСервер.ПолучитьСписокГрузовПоОстаткамКРазмещениюДляПодбора(
			ЗаказГрузоотправителя, 
			СкладДляОтбора, 
			ТекущаяОперацияСГрузом,
			ТабПодобранныхГрузов
		);
	ИначеЕсли (ПодборВМаршрутныйЛист Или ПодборВЗаказПеревозчику) И флГрузыFTL Тогда
		ТабГрузов = уатОбщегоНазначения_уэ.ПолучитьСписокГрузовПоFTLЗаказуДляМаршрутногоЛиста(ЗаказГрузоотправителя);
	Иначе
		ТабГрузов = уатОбщегоНазначенияСервер.ПолучитьСписокГрузовПоОстаткамДляПодбора(
			ЗаказГрузоотправителя, 
			ТекМаршрутныйЛист, 
			ТабПодобранныхГрузов,
			ПодборВМаршрутныйЛист
		);
	КонецЕсли;
	
	Для Каждого ТекСтрока Из ТабГрузов Цикл 
		НовСтрока = ТаблицаГрузов.Добавить();
		НовСтрока.ВыборСтрок = Истина;
		Если (ПодборВМаршрутныйЛист Или ПодборВЗаказПеревозчику) И флГрузыFTL Тогда
			НовСтрока.Груз = ТекСтрока.Номенклатура;
			НовСтрока.КоличествоОстаток = ТекСтрока.Количество;
			НовСтрока.ЕдиницаИзмерения = ТекСтрока.ЕдиницаИзмерения;
			НовСтрока.ВесБруттоОстаток = ТекСтрока.Вес;
			НовСтрока.ОбъемОстаток = ТекСтрока.Объем;
			НовСтрока.КоличествоМестОстаток = ТекСтрока.КоличествоМест;
			НовСтрока.НомерСтрокиГруза = ТекСтрока.НомерСтроки;
			НовСтрока.КоличествоПодбор = НовСтрока.КоличествоОстаток;
			НовСтрока.ВесБруттоПодбор = НовСтрока.ВесБруттоОстаток;
			НовСтрока.ОбъемПодбор = НовСтрока.ОбъемОстаток;
			НовСтрока.КоличествоМестПодбор = НовСтрока.КоличествоМестОстаток;
		Иначе
			ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрока);
			
			НовСтрока.КоличествоПодбор = НовСтрока.КоличествоОстаток;
			НовСтрока.ВесБруттоПодбор = ?(НовСтрока.КоличествоОстаток = 0, 0, НовСтрока.ВесБруттоОстаток * НовСтрока.КоличествоПодбор / НовСтрока.КоличествоОстаток);
			НовСтрока.ОбъемПодбор = ?(НовСтрока.КоличествоОстаток = 0, 0, НовСтрока.ОбъемОстаток * НовСтрока.КоличествоПодбор / НовСтрока.КоличествоОстаток);
			НовСтрока.КоличествоМестПодбор = ?(НовСтрока.КоличествоОстаток = 0, 0,НовСтрока.КоличествоМестОстаток * НовСтрока.КоличествоПодбор / НовСтрока.КоличествоОстаток);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВОХВСтроке(ТекСтрока)
	
	ТекСтрока.ВесБруттоПодбор = ТекСтрока.ВесБруттоОстаток * ТекСтрока.КоличествоПодбор / ТекСтрока.КоличествоОстаток;
	ТекСтрока.ОбъемПодбор = ТекСтрока.ОбъемОстаток * ТекСтрока.КоличествоПодбор / ТекСтрока.КоличествоОстаток;
	ТекСтрока.КоличествоМестПодбор = ТекСтрока.КоличествоМестОстаток * ТекСтрока.КоличествоПодбор / ТекСтрока.КоличествоОстаток;
	
КонецПроцедуры

#КонецОбласти
