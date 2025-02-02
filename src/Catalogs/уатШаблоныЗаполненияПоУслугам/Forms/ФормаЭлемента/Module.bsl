
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Ответственный = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнойОтветственный");
	КонецЕсли;
	
	ВариантПоставкиСТД = уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД();
	ВариантПоставкиПРОФ = уатОбщегоНазначенияПовтИсп.ВариантПоставкиПРОФ();
	ВариантПоставкиКОРП = уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП();
	Если ВариантПоставкиСТД Тогда
		Элементы.ГруппаПолучательУслуг.Видимость = Ложь;
	КонецЕсли;
		
	ЗаполнитьСписокПолей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗаписьНастроекЗаполненияПоУслугам");
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьШаблонПункта(Команда)
	ПараметрыФормы = Новый Структура("ОбъектНастройки", "Справочник_уатПунктыНазначения_ПунктОтправленияПоЗаказу");
	ОткрытьФорму("ОбщаяФорма.уатНастройкаШаблона", ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьШаблонПунктаПрибытия(Команда)
	ПараметрыФормы = Новый Структура("ОбъектНастройки", "Справочник_уатПунктыНазначения_ПунктПрибытияПоЗаказу");
	ОткрытьФорму("ОбщаяФорма.уатНастройкаШаблона", ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПолучательУслугПриИзменении(Элемент)
	Если Объект.ИспользоватьДанныеТТД
		И Объект.ПолучательУслуг = ПредопределенноеЗначение("Перечисление.уатПолучателиУслуг.НашаОрганизация") Тогда
		Объект.ИспользоватьДанныеТТД = Ложь;
	КонецЕсли;
	
	Если Объект.ИспользоватьДанныеЗаказПеревозчику
		И Объект.ПолучательУслуг = ПредопределенноеЗначение("Перечисление.уатПолучателиУслуг.Контрагент") Тогда
		Объект.ИспользоватьДанныеЗаказПеревозчику = Ложь;
	КонецЕсли;
	Если Объект.ИспользоватьДанныеРекламаций
		И Объект.ПолучательУслуг = ПредопределенноеЗначение("Перечисление.уатПолучателиУслуг.Контрагент") Тогда
		Объект.ИспользоватьДанныеРекламаций = Ложь;
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДанныеДокументовПриИзменении(Элемент)
	ЗаполнитьСписокПолей();
	УдалитьНедоступныеПоляДетализации();
	ОбновитьШаблонСодержания();
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияЗаполненияПриИзменении(Элемент)
	ОбновитьШаблонСодержания();
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияЗаполненияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьШаблонСодержания();
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияЗаполненияПослеУдаления(Элемент)
	ОбновитьШаблонСодержания();
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияЗаполненияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ЗаполнитьСписокРеквизитовОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияЗаполненияПолеРегистраПриИзменении(Элемент)
	ЗаполнитьПолеДетализацииПоПредставлению();
	ЗаполнитьСписокРеквизитовОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияЗаполненияРеквизитПриИзменении(Элемент)
	ЗаполнитьРеквизитПоПредставлению();
	ОбновитьШаблонСодержания();
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияЗаполненияРеквизитОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.ДетализацияЗаполнения.ТекущиеДанные;
	ТекСтрока.РеквизитПредставление = "";
	
	ЗаполнитьРеквизитПоПредставлению();
	ОбновитьШаблонСодержания();
	
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	Элементы.ИспользоватьДанныеТТД.Видимость = (Объект.ПолучательУслуг
		= ПредопределенноеЗначение("Перечисление.уатПолучателиУслуг.Контрагент"));
	Элементы.ИспользоватьДанныеЗаказПеревозчику.Видимость = (Объект.ПолучательУслуг
		= ПредопределенноеЗначение("Перечисление.уатПолучателиУслуг.НашаОрганизация"));
	Элементы.ИспользоватьДанныеРекламаций.Видимость = (Объект.ПолучательУслуг
		= ПредопределенноеЗначение("Перечисление.уатПолучателиУслуг.НашаОрганизация"));
	
	Если ВариантПоставкиСТД Тогда
		Элементы.ИспользоватьДанныеЗаказПеревозчику.Видимость = Ложь;
		Элементы.ИспользоватьДанныеМаршрутныйЛист.Видимость   = Ложь;
	КонецЕсли;
	Если ВариантПоставкиСТД Или ВариантПоставкиПРОФ Тогда
		Элементы.ИспользоватьДанныеРекламаций.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНедоступныеПоляДетализации()
	Сч = Объект.ДетализацияЗаполнения.Количество()-1;
	Пока Сч >= 0 Цикл
		Поле = Объект.ДетализацияЗаполнения[Сч].ПолеРегистра;
		Если ПредставленияПолей.НайтиПоЗначению(Поле) = Неопределено Тогда
			Объект.ДетализацияЗаполнения.Удалить(Сч);
		КонецЕсли;
		
		Сч = Сч - 1;
	КонецЦикла;
	
	//Если НЕ Объект.ИспользоватьДанныеТТД
	//	И НЕ Объект.ИспользоватьДанныеКорректировкаЗаписей Тогда
	//	НайтиИУдалитьПолеДетализации("ПутевойЛист");
	//КонецЕсли;
	//Если НЕ Объект.ИспользоватьДанныеЗаказПеревозчику И НЕ Объект.ИспользоватьДанныеКорректировкаЗаписей Тогда
	//	НайтиИУдалитьПолеДетализации("ЗаказПеревозчику");
	//КонецЕсли;
	//Если НЕ Объект.ИспользоватьДанныеМаршрутныйЛист И НЕ Объект.ИспользоватьДанныеЗаказНаТС
	//	И НЕ Объект.ИспользоватьДанныеЗаказПеревозчику И НЕ Объект.ИспользоватьДанныеКорректировкаЗаписей Тогда
	//	НайтиИУдалитьПолеДетализации("Заказ");
	//	НайтиИУдалитьПолеДетализации("ВсеПунктыПоЗаказу");
	//	НайтиИУдалитьПолеДетализации("ДатаНачалаПогрузки");
	//	НайтиИУдалитьПолеДетализации("ДатаОкончанияПогрузки");
	//	НайтиИУдалитьПолеДетализации("ДатаНачалаРазгрузки");
	//	НайтиИУдалитьПолеДетализации("ДатаОкончанияРазгрузки");
	//КонецЕсли;
	//Если НЕ Объект.ИспользоватьДанныеМаршрутныйЛист И НЕ Объект.ИспользоватьДанныеЗаказНаТС
	//	И НЕ Объект.ИспользоватьДанныеТТД И НЕ Объект.ИспользоватьДанныеКорректировкаЗаписей Тогда
	//	НайтиИУдалитьПолеДетализации("НомерПоУчетуКонтрагента");
	//КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьШаблонСодержания()
	Объект.Содержание = "";
	Для Каждого ТекСтрока Из Объект.ДетализацияЗаполнения Цикл
		Объект.Содержание = Объект.Содержание + "[" + ТекСтрока.ПолеРегистра;
		Если НЕ ПустаяСтрока(ТекСтрока.Реквизит) Тогда
			Объект.Содержание = Объект.Содержание + "." + ТекСтрока.Реквизит;
		КонецЕсли;
		Объект.Содержание = Объект.Содержание + "]; ";
	КонецЦикла;
	Если НЕ ПустаяСтрока(Объект.Содержание) Тогда
		Объект.Содержание = Лев(Объект.Содержание, СтрДлина(Объект.Содержание)-2);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СписокДокументовИсточникаДанных()
	Рез = Новый СписокЗначений;
	
	Если Объект.ИспользоватьДанныеТТД Тогда
		Рез.Добавить("уатТТД", "ТТД");
	КонецЕсли;
	Если Объект.ИспользоватьДанныеЗаказНаТС Тогда
		Рез.Добавить("уатЗаказГрузоотправителя", "Заказ на ТС");
	КонецЕсли;
	Если НЕ ВариантПоставкиСТД Тогда
		Если Объект.ИспользоватьДанныеЗаказПеревозчику Тогда
			Рез.Добавить("уатЗаказПеревозчику_уэ", "Заказ перевозчику");
		КонецЕсли;
		Если Объект.ИспользоватьДанныеМаршрутныйЛист Тогда
			Рез.Добавить("уатМаршрутныйЛист", "Маршрутный лист");
		КонецЕсли;
	КонецЕсли;
	Если Не ВариантПоставкиСТД И Не ВариантПоставкиПРОФ
		И Объект.ИспользоватьДанныеРекламаций Тогда
		Рез.Добавить("уатРекламация_уэ", "Рекламация");
	КонецЕсли;
	Если Объект.ИспользоватьДанныеКорректировкаЗаписей Тогда
		Рез.Добавить("уатКорректировкаЗаписейРегистров", "Корректировка записей регистров");
	КонецЕсли;
	
	Возврат Рез;
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокПолей()
	
	Макет = Справочники.уатШаблоныЗаполненияПоУслугам.ПолучитьМакет("ПоляДетализации");
	ОбластьНастроек = Макет.ПолучитьОбласть("Строки|Колонки");
	
	ПредставленияПолей = Новый СписокЗначений;
	
	Для НомерСтроки = 1 По ОбластьНастроек.ВысотаТаблицы Цикл
		флТТД              = Булево(ОбластьНастроек.Область(НомерСтроки, 3, НомерСтроки, 3).Текст);
		флЗаказНаТС        = Булево(ОбластьНастроек.Область(НомерСтроки, 4, НомерСтроки, 4).Текст);
		флЗаказПеревозчику = Булево(ОбластьНастроек.Область(НомерСтроки, 5, НомерСтроки, 5).Текст);
		флМЛ               = Булево(ОбластьНастроек.Область(НомерСтроки, 6, НомерСтроки, 6).Текст);
		флКорректировка    = Булево(ОбластьНастроек.Область(НомерСтроки, 7, НомерСтроки, 7).Текст);
		флРекламация       = Булево(ОбластьНастроек.Область(НомерСтроки, 8, НомерСтроки, 8).Текст);
		флСТД              = Булево(ОбластьНастроек.Область(НомерСтроки, 9, НомерСтроки, 9).Текст);
		
		
		флПоле = (флТТД И Объект.ИспользоватьДанныеТТД
			ИЛИ флЗаказНаТС И Объект.ИспользоватьДанныеЗаказНаТС
			ИЛИ флЗаказПеревозчику И Объект.ИспользоватьДанныеЗаказПеревозчику
			ИЛИ флМЛ И Объект.ИспользоватьДанныеМаршрутныйЛист
			ИЛИ флКорректировка И Объект.ИспользоватьДанныеКорректировкаЗаписей
			ИЛИ флРекламация И Объект.ИспользоватьДанныеРекламаций И ВариантПоставкиКОРП)
			И (флСТД ИЛИ НЕ ВариантПоставкиСТД);
		
		Если НЕ флПоле Тогда
			Продолжить;
		КонецЕсли;
		
		ТекИмя           = ОбластьНастроек.Область(НомерСтроки, 1, НомерСтроки, 1).Текст;
		ТекПредставление = ОбластьНастроек.Область(НомерСтроки, 2, НомерСтроки, 2).Текст;
		ТекКартинка      = БиблиотекаКартинок[ОбластьНастроек.Область(НомерСтроки, 10, НомерСтроки, 10).Текст];
		
		ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	КонецЦикла;
	
	Элементы.ДетализацияЗаполненияПолеРегистра.СписокВыбора.Очистить();
	Для Каждого ТекПредставление Из ПредставленияПолей Цикл
		Элементы.ДетализацияЗаполненияПолеРегистра.СписокВыбора.Добавить(ТекПредставление.Представление,,,
			ТекПредставление.Картинка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПолеДетализацииПоПредставлению()
	ТекСтрока = Элементы.ДетализацияЗаполнения.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
			
	Для Каждого ТекЭлем Из ПредставленияПолей Цикл
		Если ТекЭлем.Представление = ТекСтрока.ПолеПредставление Тогда
			ТекСтрока.ПолеРегистра = ТекЭлем.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитПоПредставлению()
	ТекСтрока = Элементы.ДетализацияЗаполнения.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ТекСтрока.РеквизитПредставление) Тогда
		ТекСтрока.Реквизит = "";
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекЭлем Из ПредставленияРеквизитов Цикл
		Если ТекЭлем.Представление = ТекСтрока.РеквизитПредставление Тогда
			ТекСтрока.Реквизит = ТекЭлем.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокРеквизитовОбъекта()
	ТекСтрока = Элементы.ДетализацияЗаполнения.ТекущиеДанные;

	ДанныеВыбора = СписокРеквизитовОбъекта(ТекСтрока.ПолеРегистра);
	Элементы.ДетализацияЗаполненияРеквизит.СписокВыбора.ЗагрузитьЗначения(ДанныеВыбора.ВыгрузитьЗначения());
	
	Если Элементы.ДетализацияЗаполненияРеквизит.СписокВыбора.НайтиПоЗначению(ТекСтрока.РеквизитПредставление) = Неопределено Тогда
		ТекСтрока.Реквизит = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СписокРеквизитовОбъекта(Поле)
	СписокВыбора = Новый СписокЗначений;
	ПредставленияРеквизитов = Новый СписокЗначений;
	
	Если Поле = "Регистратор" ИЛИ Поле = "ПутевойЛист"
		ИЛИ Поле = "Заказ" ИЛИ Поле = "ЗаказПеревозчику" Тогда
		
		Если Поле = "ПутевойЛист" Тогда
			СписокДокументов = Новый СписокЗначений;
			СписокДокументов.Добавить("уатПутевойЛист");
		ИначеЕсли Поле = "Заказ" Тогда
			СписокДокументов = Новый СписокЗначений;
			СписокДокументов.Добавить("уатЗаказГрузоотправителя");
		ИначеЕсли Поле = "ЗаказПеревозчику" Тогда
			СписокДокументов = Новый СписокЗначений;
			СписокДокументов.Добавить("уатЗаказПеревозчику_уэ");
		Иначе
			СписокДокументов = СписокДокументовИсточникаДанных();
			Если СписокДокументов.Количество() = 0 Тогда
				Возврат СписокВыбора;
			КонецЕсли;
		КонецЕсли;
		
		Для Каждого ТекВидДокумента Из СписокДокументов Цикл
			Если СписокВыбора.НайтиПоЗначению("Номер") = Неопределено Тогда
				СписокВыбора.Добавить("Номер");
				ПредставленияРеквизитов.Добавить("Номер", "Номер");
			КонецЕсли;
			Если СписокВыбора.НайтиПоЗначению("Дата") = Неопределено Тогда
				СписокВыбора.Добавить("Дата");
				ПредставленияРеквизитов.Добавить("Дата", "Дата");
			КонецЕсли;
			
			Для Каждого ТекРеквизит Из Метаданные.Документы[ТекВидДокумента.Значение].Реквизиты Цикл
				ТекРеквизит_Имя     = ТекРеквизит.Имя;
				ТекРеквизит_Синоним = ТекРеквизит.Синоним;
				
				Если Лев(ТекРеквизит_Имя, СтрДлина("Удалить")) = "Удалить" Тогда
					Продолжить;
				КонецЕсли;
				
				Если Поле = "Регистратор" И (ТекРеквизит_Имя = "АдресНазначения"
					ИЛИ ТекРеквизит_Имя = "АдресДоставки") Тогда // для Заказа и ТТД реквизит называется по-разному
					
					ТекРеквизит_Имя = "АдресПрибытия";
					ТекРеквизит_Синоним = "Адрес прибытия (доставки)"
				КонецЕсли;
									
				Если СписокВыбора.НайтиПоЗначению(ТекРеквизит_Синоним) = Неопределено Тогда
					СписокВыбора.Добавить(ТекРеквизит_Синоним);
					ПредставленияРеквизитов.Добавить(ТекРеквизит_Имя, ТекРеквизит_Синоним);
				КонецЕсли;
			КонецЦикла;
			
			мсвДопРеквизиты = УправлениеСвойствами.СвойстваОбъекта(Документы[ТекВидДокумента.Значение].ПустаяСсылка());
			Для Каждого ТекРеквизит Из мсвДопРеквизиты Цикл
				ТекПредставление = ТекРеквизит.Наименование + " (доп.)";
				Если СписокВыбора.НайтиПоЗначению(ТекПредставление) = Неопределено Тогда
					СписокВыбора.Добавить(ТекПредставление);
					ПредставленияРеквизитов.Добавить(ТекРеквизит.ИдентификаторДляФормул, ТекПредставление);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	Иначе
		Если Поле = "ТС" ИЛИ Поле = "Прицепы" Тогда
			ИмяСправочника = "уатТС";
		ИначеЕсли Поле = "Водитель" Тогда
			ИмяСправочника = "Сотрудники";
		ИначеЕсли Поле = "Услуга" Тогда
			ИмяСправочника = "Номенклатура";
		ИначеЕсли Поле = "ПараметрВыработки" Тогда
			ИмяСправочника = "уатПараметрыВыработки";
		ИначеЕсли Поле = "Маршрут" Тогда
			ИмяСправочника = "уатМаршруты";
		ИначеЕсли Поле = "ОбъектСтроительства" Тогда
			ИмяСправочника = "уатОбъектыСтроительства";
		Иначе
			Возврат СписокВыбора;
		КонецЕсли;
		
		СписокВыбора.Добавить("Код");
		СписокВыбора.Добавить("Наименование");
		ПредставленияРеквизитов.Добавить("Код", "Код");
		ПредставленияРеквизитов.Добавить("Наименование", "Наименование");
		
		Для Каждого ТекРеквизит Из Метаданные.Справочники[ИмяСправочника].Реквизиты Цикл
			Если Лев(ТекРеквизит.Имя, СтрДлина("Удалить")) = "Удалить" Тогда
				Продолжить;
			КонецЕсли;
			Если СписокВыбора.НайтиПоЗначению(ТекРеквизит.Имя) = Неопределено Тогда
				СписокВыбора.Добавить(ТекРеквизит.Синоним);
				ПредставленияРеквизитов.Добавить(ТекРеквизит.Имя, ТекРеквизит.Синоним);
			КонецЕсли;
		КонецЦикла;
		
		мсвДопРеквизиты = УправлениеСвойствами.СвойстваОбъекта(Справочники[ИмяСправочника].ПустаяСсылка());
		Для Каждого ТекРеквизит Из мсвДопРеквизиты Цикл
			ТекПредставление = ТекРеквизит.Наименование + " (доп.)";
			Если СписокВыбора.НайтиПоЗначению(ТекПредставление) = Неопределено Тогда
				СписокВыбора.Добавить(ТекПредставление);
				ПредставленияРеквизитов.Добавить(ТекРеквизит.ИдентификаторДляФормул, ТекПредставление);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	СписокВыбора.СортироватьПоЗначению();
	
	Возврат СписокВыбора;
КонецФункции

#КонецОбласти
