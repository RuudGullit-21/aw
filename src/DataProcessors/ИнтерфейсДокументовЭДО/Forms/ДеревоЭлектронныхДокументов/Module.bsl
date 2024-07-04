#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Параметры.Свойство("ИсходныйДокумент", ИсходныйДокумент);
	ОбъектУчета = Неопределено;
	Параметры.Свойство("ОбъектУчета", ОбъектУчета);

	Если ЗначениеЗаполнено(ОбъектУчета) Тогда
		ОбъектСсылка = ОбъектУчета;
		ОбновитьДеревоЭД();
	КонецЕсли;

	Элементы.ЖурналСобытий.Доступность = Пользователи.ЭтоПолноправныйПользователь();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = ИнтерфейсДокументовЭДОКлиент.ИмяСобытияОбновленияСостоянияЭДО() Тогда

		Если ТипЗнч(Параметр) = Тип("Структура") 
			И Параметр.Свойство("ДокументыУчета") 
			И ТипЗнч(Параметр.ДокументыУчета) = Тип("Массив") 
			И Параметр.ДокументыУчета.Количество() > 0
			И Параметр.ДокументыУчета.Найти(ОбъектСсылка) = Неопределено Тогда

			Возврат;

		КонецЕсли;

		ВывестиДеревоЭД();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	РазвернутьСтроки();

	Если ЗначениеЗаполнено(ИсходныйДокумент) Тогда
		УстановитьТекущуюСтроку();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодчиненныеЭД

&НаКлиенте
Процедура ДеревоПодчиненныеЭДВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ДеревоПодчиненныеЭДДействие" Тогда
			СтандартнаяОбработка = Ложь;
			ВыполняемоеДействие = Элемент.ТекущиеДанные.ОжидаемоеДействие;

			Оповещение = Новый ОписаниеОповещения("ПослеВыполненияДействийПоЭДО", ЭтотОбъект);
			НаборДействий = Новый Соответствие;
			ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ВыполняемоеДействие);

			ПараметрыВыполненияДействийПоЭДО = ЭлектронныеДокументыЭДОКлиентСервер.НовыеПараметрыВыполненияДействийПоЭДО();
			ПараметрыВыполненияДействийПоЭДО.НаборДействий = НаборДействий;
			ПараметрыВыполненияДействийПоЭДО.ОбъектыДействий.ЭлектронныеДокументы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				Элемент.ТекущиеДанные.ЭлектронныйДокумент);

			ЭлектронныеДокументыЭДОКлиент.НачатьВыполнениеДействийПоЭДО(Оповещение, ПараметрыВыполненияДействийПоЭДО);
			Если ЗначениеЗаполнено(Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока)
				И ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() > 1 Тогда
				Элементы.ДеревоПодчиненныеЭД.Развернуть(Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока, Истина);
			КонецЕсли;

		Иначе
			ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокумент(Элемент.ТекущиеДанные.ЭлектронныйДокумент);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыполненияДействийПоЭДО(Результат, Контекст) Экспорт
	
	Если ОбработкаНеисправностейБЭДКлиентСервер.ЕстьОшибки(Контекст) Тогда
		ОбработкаНеисправностейБЭДКлиент.ОбработатьОшибки(Контекст);
	Иначе

		ВывестиДеревоЭД();

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодчиненныеЭДПередНачаломИзменения(Элемент, Отказ)

	Отказ = Истина;
	Если Элемент.ТекущийЭлемент <> Неопределено Тогда

		Если Элемент.ТекущийЭлемент.Имя = "ДеревоПодчиненныеЭДНаименование" Тогда

			Если Элемент.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Документооборот) Тогда

				ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокумент(Элемент.ТекущиеДанные.Документооборот);
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьПолучитьЭлектронныеДокументы(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОтправкаПолучениеЭДЗавершение", ЭтотОбъект);
	ИнтерфейсДокументовЭДОКлиент.НачатьОтправкуПолучениеДокументов(ЭтотОбъект, Оповещение);	

КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)

	Если Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ОбновитьНаСервере(Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные.ЭлектронныйДокумент);
	РазвернутьСтроки();
	УстановитьТекущуюСтроку();

КонецПроцедуры

&НаКлиенте
Процедура ЖурналСобытий(Команда)

	ЭлектронныйДокумент = Неопределено;
	
	Если Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные <> Неопределено Тогда
		ЭлектронныйДокумент = Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные.ЭлектронныйДокумент;
	КонецЕсли;
	
	ЭлектронныеДокументыЭДОКлиент.ОткрытьЖурналДействийПоЭДО(ЭлектронныйДокумент);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьАктуальныйДокументооборот(Команда)
	
	Если Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	
	Если Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные.ЭлектронныйДокумент <> Неопределено Тогда
		УстановитьАктуальныйДокументооборотНаСервере(ОбъектСсылка, Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные.ЭлектронныйДокумент);
	КонецЕсли;	
	
	ОбновитьНаСервере(Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные.ЭлектронныйДокумент);
	РазвернутьСтроки();
	УстановитьТекущуюСтроку();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтправкаПолучениеЭДЗавершение(Результат, Контекст) Экспорт

	Если Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ОбновитьНаСервере(Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные.ЭлектронныйДокумент);
	РазвернутьСтроки();
	УстановитьТекущуюСтроку();

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокИдентификаторовСтрокДерева(Форма)

	Форма.СписокИдентификаторов.Очистить();
	Для Каждого ЭлементДерева Из Форма.ДеревоПодчиненныеЭД.ПолучитьЭлементы() Цикл
		Если ЭлементДерева.Актуальный И Не ЭлементДерева.Статус = ПредопределенноеЗначение(
			"Перечисление.СтатусыСообщенийЭДО.УдалитьОтклонен") Тогда
			Форма.СписокИдентификаторов.Добавить(ЭлементДерева.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСтроки()

	Если СписокИдентификаторов.Количество() = 0 Тогда
		ЗаполнитьСписокИдентификаторовСтрокДерева(ЭтотОбъект);
	КонецЕсли;

	Для Каждого Строка Из СписокИдентификаторов Цикл
		Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока = Строка.Значение;
		Элементы.ДеревоПодчиненныеЭД.Развернуть(Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока, Истина);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере(ТекущаяСсылка)

	ОбновитьДеревоЭД();
	ОбновитьИндексТекущейСтроки(ТекущаяСсылка);

КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоЭД()

	СформироватьДеревьяЭД();

	Заголовок = НСтр("ru = 'Электронные документы:'") + " " + ОбъектСсылка;

КонецПроцедуры

&НаСервере
Процедура СформироватьДеревьяЭД()

	ДеревоПодчиненныеЭД.ПолучитьЭлементы().Очистить();

	Если ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО") Или ТипЗнч(ОбъектСсылка) = Тип(
		"ДокументСсылка.ЭлектронныйДокументИсходящийЭДО") Тогда

		Документообороты = Новый Массив;
		Документообороты.Добавить(ОбъектСсылка);
		СоответствиеВладельцевИЭД = ИнтеграцияЭДО.ОбъектыУчетаЭлектронныхДокументов(Документообороты);

	Иначе

		ОбъектыУчета = Новый Массив;
		ОбъектыУчета.Добавить(ОбъектСсылка);

		СоответствиеВладельцевИЭД = ИнтеграцияЭДО.ЭлектронныеДокументыОбъектовУчета(ОбъектыУчета);

	КонецЕсли;

	ДеревоОбъект = РеквизитФормыВЗначение("ДеревоПодчиненныеЭД");

	ИнтерфейсДокументовЭДО.СформироватьДеревьяЭД(ДеревоОбъект, СоответствиеВладельцевИЭД);

	ЗначениеВРеквизитФормы(ДеревоОбъект, "ДеревоПодчиненныеЭД");

	ЗаполнитьСписокИдентификаторовСтрокДерева(ЭтотОбъект);
	ЗаполнитьИндексИД(ДеревоПодчиненныеЭД, ИсходныйДокумент);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьАктуальныйДокументооборотНаСервере(ОбъектУчета, ЭлектронныйДокумент)
	
	НаборОбъектовУчета = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОбъектУчета);	
	ИнтеграцияЭДО.УстановитьАктуальныйЭлектронныйДокумент(НаборОбъектовУчета, ЭлектронныйДокумент);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИндексИД(ДеревоЭД, Ссылка)

	Для Каждого ЭлементДерева Из ДеревоЭД.ПолучитьЭлементы() Цикл

		Если ЭлементДерева.ЭлектронныйДокумент = Ссылка Тогда
			ИндексИД = ЭлементДерева.ПолучитьИдентификатор();
		КонецЕсли;

		Если ЭлементДерева.ПолучитьЭлементы().Количество() > 0 Тогда
			ЗаполнитьИндексИД(ЭлементДерева, Ссылка);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтроку()

	Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока = ИндексИД;

КонецПроцедуры

// Инициирует вывод в дерево и отображает его по окончанию формирования.
&НаКлиенте
Процедура ВывестиДеревоЭД()

	ОбновитьДеревоЭД();
	РазвернутьСтроки();

КонецПроцедуры

&НаСервере
Процедура ОбновитьИндексТекущейСтроки(ТекущаяСсылка)

	ЗаполнитьИндексИД(ДеревоПодчиненныеЭД, ТекущаяСсылка);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭД.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.ЭлектронныйДокумент");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.СтрокаДоступна");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДСтатус.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.СтатусыСообщенийЭДО.Получен);
	СписокЗначений.Добавить(Перечисления.СтатусыСообщенийЭДО.УдалитьПереданОператору);
	СписокЗначений.Добавить(Перечисления.СтатусыСообщенийЭДО.Отправлен);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.СтатусыСообщенийЭДО.УдалитьДоставлен);
	СписокЗначений.Добавить(Перечисления.СтатусыСообщенийЭДО.Утвержден);
	СписокЗначений.Добавить(Перечисления.СтатусыСообщенийЭДО.УдалитьДоставлен);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.ВидДокумента.ТипДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ТипыДокументовЭДО.ТоварнаяНакладная);
	СписокЗначений.Добавить(Перечисления.ТипыДокументовЭДО.АктВыполненныхРабот);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.СтатусыСообщенийЭДО.Получен);
	СписокЗначений.Добавить(Перечисления.СтатусыСообщенийЭДО.УдалитьДоставлен);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.ВидДокумента.ТипДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ТипыДокументовЭДО.ТоварнаяНакладная);
	СписокЗначений.Добавить(Перечисления.ТипыДокументовЭДО.АктВыполненныхРабот);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	ГруппаОтбора3 = ГруппаОтбора2.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора3.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ГруппаОтбора4 = ГруппаОтбора3.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора4.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора4.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.Направление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.НаправленияЭДО.Входящий;
	ОтборЭлемента = ГруппаОтбора4.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыСообщенийЭДО.Утвержден;
	ОтборЭлемента = ГруппаОтбора3.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.СтатусыСообщенийЭДО.УдалитьПолученоПодтверждение);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Green);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДНаименование.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДВерсия.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДСтатус.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.Актуальный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина,
		Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДВерсия.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.ДатаЭДБольшеАктуального");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(255, 0, 0));

КонецПроцедуры

#КонецОбласти