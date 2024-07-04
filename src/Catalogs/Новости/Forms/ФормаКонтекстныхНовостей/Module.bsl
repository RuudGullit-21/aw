///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

#Область ЗаполнитьТаблицуНовостей

	Если Параметры.ПропуститьЗаполнениеНовостями = Истина Тогда

		ВременнаяТаблицаНовостей = ЭтотОбъект.ТаблицаНовостей.Выгрузить();

	Иначе

		// Если передали явный список лент новостей, то использовать его.
		// В противном случае рассчитать только видимые пользователю ленты новостей.
		Если Параметры.СписокЛентНовостей.Количество() > 0 Тогда
			лкСписокЛентНовостей = Параметры.СписокЛентНовостей;
		Иначе
			МассивДоступныхЛентНовостей = ХранилищаНастроек.НастройкиНовостей.Загрузить(
				"ДоступныеЛентыНовостей", // КлючОбъекта
				""); // КлючНастроек, пока не обрабатывается
			лкСписокЛентНовостей = Новый СписокЗначений;
			лкСписокЛентНовостей.ЗагрузитьЗначения(МассивДоступныхЛентНовостей);
		КонецЕсли;

		НастройкиПолученияНовостей = Неопределено;
		ВременнаяТаблицаНовостей = ОбработкаНовостей.ПолучитьКонтекстныеНовости(
			лкСписокЛентНовостей,
			?(ПустаяСтрока(Параметры.ИмяМетаданных), Неопределено, Параметры.ИмяМетаданных),
			?(ПустаяСтрока(Параметры.ИмяФормы), Неопределено, Параметры.ИмяФормы),
			?(ПустаяСтрока(Параметры.ИмяСобытия), Неопределено, Параметры.ИмяСобытия),
			"Для формы контекстных новостей", // Вариант запроса для контекстных новостей.
			НастройкиПолученияНовостей);

	КонецЕсли;

	ДополнитьНовости(ВременнаяТаблицаНовостей, Параметры.СписокНовостей, Параметры.СортировкаСпискаНовостей);

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьТаблицуКонтекстныхНовостей(
		?(ПустаяСтрока(Параметры.ИмяМетаданных), Неопределено, Параметры.ИмяМетаданных),
		?(ПустаяСтрока(Параметры.ИмяФормы), Неопределено, Параметры.ИмяФормы),
		?(ПустаяСтрока(Параметры.ИмяСобытия), Неопределено, Параметры.ИмяСобытия),
		ВременнаяТаблицаНовостей);

	// Эта форма используется для открытия формы контекстных новостей при нажатии кнопки "Показать все новости для этой формы",
	//  а не для показа новостей при открытии формы ("напрыгивание" формы).
	//  Поэтому удалять новости с СпособОповещения = "Отключить" не нужно.

	ЭтотОбъект.ТаблицаНовостей.Загрузить(ВременнаяТаблицаНовостей);

#КонецОбласти

	Если Параметры.СкрыватьКолонкуПодзаголовок = Истина Тогда
		Элементы.ТаблицаНовостейПодзаголовок.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.СкрыватьКолонкуДатаПубликации = Истина Тогда
		Элементы.ТаблицаНовостейДатаПубликации.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.СкрыватьКолонкуЛентаНовостей = Истина Тогда
		Элементы.ТаблицаНовостейЛентаНовостей.Видимость = Ложь;
	КонецЕсли;

	Если (Параметры.ПоказыватьПанельПоиска = Истина) Тогда
		Элементы.ГруппаПоиск.Видимость = Истина;
	Иначе
		Элементы.ГруппаПоиск.Видимость = Ложь;
	КонецЕсли;

	Если (Параметры.ПоказыватьПанельНавигации = Истина)
			И (ОбработкаНовостейПовтИсп.ЕстьРолиЧтенияНовостей()) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

	Если НЕ ПустаяСтрока(Параметры.ЗаголовокФормы) Тогда
		ЭтотОбъект.Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;

	Если ВРег(СокрЛП(Параметры.РежимОткрытияОкна)) = ВРег("Независимый") Тогда
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	ИначеЕсли (ВРег(СокрЛП(Параметры.РежимОткрытияОкна)) = ВРег("Блокировать весь интерфейс"))
			ИЛИ (ВРег(СокрЛП(Параметры.РежимОткрытияОкна)) = ВРег("БлокироватьВесьИнтерфейс")) Тогда
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	Иначе // Блокировать окно владельца
		//
	КонецЕсли;

	УстановитьУсловноеОформление();

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуКонтекстныхНовостейПриСозданииНаСервере(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЭтотОбъект.ТаблицаНовостей.Количество() <= 0 Тогда
		Отказ = Истина;
		// Вывести сообщение, что нет контекстных новостей
		ТекстСообщения     = НСтр("ru = 'Для этой формы нет контекстных новостей.'; en = 'No context news for this form.'");
		ПояснениеСообщения = НСтр("ru = 'Нажмите здесь для просмотра всех новостей.'; en = 'Click here to view all news.'");
		ОбработкаНовостейКлиентПереопределяемый.ПереопределитьНадписиСообщенияПриОтсутствииКонтекстныхНовостей(
			ЭтотОбъект,
			ТекстСообщения,
			ПояснениеСообщения,
			Отказ);
		Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
			ПоказатьОповещениеПользователя(
				ТекстСообщения, // Текст,
				ОбработкаНовостейКлиент.ПолучитьНавигационнуюСсылкуСпискаНовостей(), // НавигационнаяСсылка
				ПояснениеСообщения, // Пояснение,
				БиблиотекаКартинок.Новости); // Картинка
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Новость прочтена" Тогда
		// Если новостей > 20, то это может привести к неявному вызову сервера
		НайденныеСтроки = ЭтотОбъект.ТаблицаНовостей.НайтиСтроки(Новый Структура("Новость", Источник)); // Источник = Новость
		Для каждого ТекущаяСтрока Из НайденныеСтроки Цикл
			ТекущаяСтрока.Прочтена = Параметр; // Параметр = Прочтена
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)

	ЭтотОбъект.СтрокаПоиска = СокрЛП(ЭтотОбъект.СтрокаПоиска);
	КомандаПоиск(Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)

	КомандаПоиск(Неопределено);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ТаблицаНовостей

&НаКлиенте
Процедура ТаблицаНовостейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ВыбраннаяСтрока <> Неопределено Тогда
		НайденнаяНовость = ЭтотОбъект.ТаблицаНовостей.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если НайденнаяНовость <> Неопределено Тогда
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("РежимОткрытияОкна", "БлокироватьОкноВладельца");
			ИнициаторОткрытияНовости = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"ФормаКонтекстныхНовостей/Метаданные=%1/Форма=%2/Событие=%3/Действие=ДвойнойКлик", // Идентификатор.
				Параметры.ИмяМетаданных,
				Параметры.ИмяФормы,
				Параметры.ИмяСобытия);
			ПараметрыОткрытияФормы.Вставить("ИнициаторОткрытияНовости", ИнициаторОткрытияНовости);
			ПараметрыОткрытияФормы.Вставить("НовостьНаименование", НайденнаяНовость.НовостьНаименование); // Заголовок новости.
			ПараметрыОткрытияФормы.Вставить("НовостьКодЛентыНовостей", НайденнаяНовость.НовостьКодЛентыНовостей); // Код ленты новостей.
			ОбработкаНовостейКлиент.ПоказатьНовость(
				НайденнаяНовость.Новость,
				ПараметрыОткрытияФормы, // Параметры.
				ЭтотОбъект,
				Истина); // Без уникальности.
			// Если не отменить стандартную обработку, то при открытии новости из списка по нажатию Enter,
			//  то это нажатие вернется обратно в форму и будет активизирован следующий элемент управления, например "СтрокаПоиска".
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОткрытьНовость(Команда)

	ТекущиеДанные = Элементы.ТаблицаНовостей.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("РежимОткрытияОкна", "БлокироватьОкноВладельца");
		ИнициаторОткрытияНовости = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"ФормаКонтекстныхНовостей/Метаданные=%1/Форма=%2/Событие=%3/Действие=КомандаОткрыть", // Идентификатор.
			Параметры.ИмяМетаданных,
			Параметры.ИмяФормы,
			Параметры.ИмяСобытия);
		ПараметрыОткрытияФормы.Вставить("ИнициаторОткрытияНовости", ИнициаторОткрытияНовости);
		ПараметрыОткрытияФормы.Вставить("НовостьНаименование", ТекущиеДанные.НовостьНаименование); // Заголовок новости.
		ПараметрыОткрытияФормы.Вставить("НовостьКодЛентыНовостей", ТекущиеДанные.НовостьКодЛентыНовостей); // Код ленты новостей.
		ОбработкаНовостейКлиент.ПоказатьНовость(
			ТекущиеДанные.Новость,
			ПараметрыОткрытияФормы, // Параметры.
			ЭтотОбъект,
			Истина); // Без уникальности.
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаПоиск(Команда)

	// Поиск осуществляется только внутри "ТаблицаНовостей".
	// Сам список "ТаблицаНовостей" не изменяется, только скрываются / отображаются новости.
	// Регулировка показа / скрытия осуществляется значением в колонке "СкрыватьНовость".
	Если ПустаяСтрока(ЭтотОбъект.СтрокаПоиска) Тогда // Очистить поиск - показать все новости.
		Для Каждого ТекущаяСтрока Из ТаблицаНовостей Цикл
			ТекущаяСтрока.СкрыватьНовость = Ложь;
		КонецЦикла;
		Элементы.ТаблицаНовостей.ОтборСтрок = Неопределено;
	Иначе // Найти новости из списка существующих в "ТаблицаНовостей".
		НовостиОбластьПоиска = Новый Массив;
		Для Каждого ТекущаяСтрока Из ТаблицаНовостей Цикл
			НовостиОбластьПоиска.Добавить(ТекущаяСтрока.Новость);
		КонецЦикла;
		СтруктураПараметровПоиска = Новый Структура;
			СтруктураПараметровПоиска.Вставить("СтрокаПоиска"        , ЭтотОбъект.СтрокаПоиска);
			СтруктураПараметровПоиска.Вставить("НовостиОбластьПоиска", НовостиОбластьПоиска);
		МассивНайденныхНовостей = ОбработкаНовостейКлиент.НайтиНовости(СтруктураПараметровПоиска);
		Для Каждого ТекущаяСтрока Из ТаблицаНовостей Цикл
			Если МассивНайденныхНовостей.Найти(ТекущаяСтрока.Новость) = Неопределено Тогда
				ТекущаяСтрока.СкрыватьНовость = Истина;
			Иначе
				ТекущаяСтрока.СкрыватьНовость = Ложь;
			КонецЕсли;
		КонецЦикла;
		Элементы.ТаблицаНовостей.ОтборСтрок = Новый ФиксированнаяСтруктура("СкрыватьНовость", Ложь);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Непрочтенные новости (ДатаПубликации, Наименование и Подзаголовок) - жирным.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейНаименование.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейПодзаголовок.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейДатаПубликации.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейЛентаНовостей.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаНовостей.Прочтена");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ШрифтНовостей, , , Истина)); // Жирный

		// Использование
		Элемент.Использование = Истина;

	// Другие произвольные настройки условного оформления, настраиваемые для конкретной конфигурации.
	ОбработкаНовостейПереопределяемый.ДополнительноУстановитьУсловноеОформлениеФормыКонтекстныхНовостей(ЭтотОбъект, УсловноеОформление);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДополнитьНовости(ВременнаяТаблицаНовостей, СписокНовостей, СортировкаСпискаНовостей)

#Область ИнициализацияМетода

	ТипСписокЗначений = Тип("СписокЗначений");

	БылиДобавления = Ложь;

	Если ПустаяСтрока(СортировкаСпискаНовостей) Тогда
		КолонкиСортировки = "ДатаПубликации УБЫВ";
	Иначе
		КолонкиСортировки = СортировкаСпискаНовостей;
	КонецЕсли;

#КонецОбласти

#Область Проверки

	Если (ТипЗнч(СписокНовостей) <> ТипСписокЗначений) Тогда
		Возврат;
	КонецЕсли;
	Если (СписокНовостей.Количество() <= 0) Тогда
		Возврат;
	КонецЕсли;

#КонецОбласти

#Область Обработка

	// Никакие дополнительные проверки списка новостей НЕ производятся (пометка удаления, просроченность).
	Запрос = Новый Запрос;
	Запрос.Текст = "
		|// Набор полей должен быть таким, чтобы исключить задвоение новостей.
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	0                                                        КАК НомерСтрокиНовости,
		|	Рег.Новость.ЛентаНовостей                                КАК ЛентаНовостей,
		|	Рег.Новость                                              КАК Новость,
		|	Рег.Новость.Наименование                                 КАК НовостьНаименование,
		|	Рег.Новость.Подзаголовок                                 КАК НовостьПодзаголовок,
		|	Рег.Новость.ЛентаНовостей.Код                            КАК НовостьКодЛентыНовостей,
		|	Рег.Новость.УИННовости                                   КАК УИННовости,
		|	Рег.Новость.ДатаПубликации                               КАК ДатаПубликации,
		|	Рег.Метаданные                                           КАК Метаданные,
		|	Рег.ЭтоПостояннаяНовость                                 КАК ЭтоПостояннаяНовость,
		|	ЕСТЬNULL(РегСостояния.Прочтена, ЛОЖЬ)                    КАК Прочтена,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(РегСостояния.ДатаНачалаОповещения, &ПустаяДата) <= &ТекущаяУниверсальнаяДата ТОГДА
		|			ЕСТЬNULL(РегСостояния.ОповещениеВключено, ИСТИНА)
		|		ИНАЧЕ
		|			ЛОЖЬ
		|	КОНЕЦ                                                    КАК ОповещениеВключено,
		|	ЕСТЬNULL(РегСостояния.ДатаНачалаОповещения, &ПустаяДата) КАК ДатаНачалаОповещения,
		|	НЕОПРЕДЕЛЕНО                                             КАК ИконкаНовости,
		|	ВЫБОР // {Получение способа оповещения}
		|		КОГДА Рег.Новость.ЛентаНовостей.ПометкаУдаления ТОГДА // Значение через точку.
		|			&СпособОповещенияОтключеноСсылка
		|		КОГДА Рег.Новость.ЛентаНовостей.ОбязательныйКанал ТОГДА // Значение через точку.
		|			&СпособОповещенияПоУмолчаниюСсылка
		|		ИНАЧЕ
		|			ЕСТЬNULL(РегОповещения.СпособОповещенияПользователяОНовостях, &СпособОповещенияПоУмолчаниюСсылка)
		|	КОНЕЦ                                                    КАК СпособОповещенияСсылка,
		|	&СпособОповещенияПоУмолчаниюСтрока                       КАК СпособОповещения
		|ИЗ
		|	РегистрСведений.ПривязкаНовостейКМетаданным КАК Рег
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.СостоянияНовостей КАК РегСостояния
		|	ПО
		|		РегСостояния.Новость = Рег.Новость
		|		И РегСостояния.Пользователь = &ТекущийПользователь
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.НастройкиЛентНовостейПользовательские КАК РегОповещения
		|	ПО
		|		&ТекущийПользователь = РегОповещения.Пользователь
		|		И Рег.Новость.ЛентаНовостей = РегОповещения.ЛентаНовостей // Значение через точку.
		|
		|ГДЕ
		|	Рег.Новость В (&Новости)
		|;
		|";
	Запрос.УстановитьПараметр("ТекущийПользователь"              , Пользователи.ТекущийПользователь()); // В модели сервиса запускается только с включенным разделителем.
	Запрос.УстановитьПараметр("ТекущаяУниверсальнаяДата"         , ТекущаяУниверсальнаяДата());
	Запрос.УстановитьПараметр("ПустаяДата"                       , '00010101000000');
	Запрос.УстановитьПараметр("Новости"                          , СписокНовостей.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("СпособОповещенияОтключеноСсылка"  , Перечисления.СпособыОповещенияПользователяОНовостях.Отключено);
	Запрос.УстановитьПараметр("СпособОповещенияПоУмолчаниюСсылка", Перечисления.СпособыОповещенияПользователяОНовостях.ПоУмолчанию);
	Запрос.УстановитьПараметр("СпособОповещенияПоУмолчаниюСтрока", "ПоУмолчанию"); // Идентификатор.

	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);
		Пока Выборка.Следующий() Цикл
			// Проверить - нет ли такой новости во ВременнаяТаблицаНовостей? Если НЕТ, то добавить.
			НайденнаяСтрока = ВременнаяТаблицаНовостей.Найти(Выборка.Новость, "Новость");
			Если НайденнаяСтрока = Неопределено Тогда
				НоваяСтрока = ВременнаяТаблицаНовостей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
				// {При добавлении способов оповещения исправлять здесь}.
				Если Выборка.СпособОповещенияСсылка = Перечисления.СпособыОповещенияПользователяОНовостях.Отключено Тогда
					НоваяСтрока.СпособОповещения = "Отключено"; // Идентификатор.
				Иначе
					НоваяСтрока.СпособОповещения = "ПоУмолчанию"; // Идентификатор.
				КонецЕсли;
				БылиДобавления = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

#КонецОбласти

#Область Завершение

	Если БылиДобавления = Истина Тогда
		ВременнаяТаблицаНовостей.Сортировать(КолонкиСортировки);
	КонецЕсли;

#КонецОбласти

КонецПроцедуры

#КонецОбласти
