///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПустаяСтрока(Параметры.Тег) Тогда
		ЭтотОбъект.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Добавление тега %1'; en = 'Add tag %1'"),
			ВРег(Параметры.Тег));
	Иначе
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ЭтотОбъект.ВыделенныйТекст = Параметры.ВыделенныйТекст;
	ЭтотОбъект.Тег             = Параметры.Тег;

	// Для текста
	//  <b style="color:red; ">
	// в этот параметр будет передано
	//  style="color:red; ".
	РаспарситьАтрибуты(Параметры.Атрибуты);

	УправлениеФормой(ЭтотОбъект);

	Если (ВРег(ЭтотОбъект.Тег) = ВРег("p"))
			ИЛИ (ВРег(ЭтотОбъект.Тег) = ВРег("div")) Тогда
		Элементы.ГруппаВыравниваниеАбзаца.Видимость = Истина;
	Иначе
		Элементы.ГруппаВыравниваниеАбзаца.Видимость = Ложь;
		ЭтотОбъект.ФорматВыравниваниеАбзацаПоУмолчанию = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ЭтотОбъект.Пример = ПолучитьПредставлениеАтрибутов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомандаВыравниваниеАбзаца(Команда)

	СброситьВсе = Ложь;
	УстановитьПометку = 0;

	// Если пометка уже была, то сбросить все пометки.
	// Если пометки не было, то сбросить все, а эту установить.
	Если Команда.Имя = "КомандаВыравниваниеАбзацаВлево" Тогда // 1
		Если Элементы.КомандаВыравниваниеАбзацаВлево.Пометка = Истина Тогда
			СброситьВсе = Истина;
		Иначе
			УстановитьПометку = 1
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаВыравниваниеАбзацаВправо" Тогда // 2
		Если Элементы.КомандаВыравниваниеАбзацаВлево.Пометка = Истина Тогда
			СброситьВсе = Истина;
		Иначе
			УстановитьПометку = 2
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаВыравниваниеАбзацаПоЦентру" Тогда // 3
		Если Элементы.КомандаВыравниваниеАбзацаВлево.Пометка = Истина Тогда
			СброситьВсе = Истина;
		Иначе
			УстановитьПометку = 3
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаВыравниваниеАбзацаПоШирине" Тогда // 4
		Если Элементы.КомандаВыравниваниеАбзацаВлево.Пометка = Истина Тогда
			СброситьВсе = Истина;
		Иначе
			УстановитьПометку = 4
		КонецЕсли;
	КонецЕсли;

	Элементы.КомандаВыравниваниеАбзацаВлево.Пометка    = Ложь;
	Элементы.КомандаВыравниваниеАбзацаВправо.Пометка   = Ложь;
	Элементы.КомандаВыравниваниеАбзацаПоЦентру.Пометка = Ложь;
	Элементы.КомандаВыравниваниеАбзацаПоШирине.Пометка = Ложь;
	Если СброситьВсе = Ложь Тогда
		ЭтотОбъект.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
		ЭтотОбъект.ФорматВыравниваниеАбзаца = УстановитьПометку;
		Если УстановитьПометку = 1 Тогда
			Элементы.КомандаВыравниваниеАбзацаВлево.Пометка    = Истина;
		ИначеЕсли УстановитьПометку = 2 Тогда
			Элементы.КомандаВыравниваниеАбзацаВправо.Пометка   = Истина;
		ИначеЕсли УстановитьПометку = 3 Тогда
			Элементы.КомандаВыравниваниеАбзацаПоЦентру.Пометка = Истина;
		ИначеЕсли УстановитьПометку = 4 Тогда
			Элементы.КомандаВыравниваниеАбзацаПоШирине.Пометка = Истина;
		КонецЕсли;
	Иначе
		ЭтотОбъект.ФорматВыравниваниеАбзацаПоУмолчанию = Истина;
	КонецЕсли;

	ЭтотОбъект.Пример = ПолучитьПредставлениеАтрибутов();

КонецПроцедуры

&НаКлиенте
Процедура ФорматЦветТекстаПриИзменении(Элемент)

	ЭтотОбъект.ФорматЦветТекстаПоУмолчанию = Ложь;
	ЭтотОбъект.Пример = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ФорматЦветТекстаОчистка(Элемент, СтандартнаяОбработка)

	ЭтотОбъект.ФорматЦветТекстаПоУмолчанию = Истина;
	ЭтотОбъект.ФорматЦветТекста            = Новый Цвет;
	ЭтотОбъект.Пример                      = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтотОбъект);
	СтандартнаяОбработка = Ложь; // Чтобы не срабатывало "ПриИзменении".

КонецПроцедуры

&НаКлиенте
Процедура ФорматЦветФонаПриИзменении(Элемент)

	ЭтотОбъект.ФорматЦветФонаПоУмолчанию = Ложь;
	ЭтотОбъект.Пример = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ФорматЦветФонаОчистка(Элемент, СтандартнаяОбработка)

	ЭтотОбъект.ФорматЦветФонаПоУмолчанию = Истина;
	ЭтотОбъект.ФорматЦветФона            = Новый Цвет;
	ЭтотОбъект.Пример                    = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтотОбъект);
	СтандартнаяОбработка = Ложь; // Чтобы не срабатывало "ПриИзменении".

КонецПроцедуры

&НаКлиенте
Процедура ФорматВсплывающаяПодсказкаПриИзменении(Элемент)

	ЭтотОбъект.Пример = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ФорматВсплывающаяПодсказкаОчистка(Элемент, СтандартнаяОбработка)

	ЭтотОбъект.Пример = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)

	Если ПроверитьЗаполнение() Тогда
		ТегНачала = "<" + ЭтотОбъект.Тег + " " + ЭтотОбъект.ТекстАтрибутов + ">";
		ТегНачала = СтрЗаменить(ТегНачала, "  ", " ");
		Результат =
			Новый Структура("ТегНачала, ТегОкончания",
				ТегНачала,
				"</" + ЭтотОбъект.Тег + ">");
		ЭтотОбъект.Закрыть(Результат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Функция возвращает строковое представление всех установленных атрибутов форматирования:
// <тег
//  title="ВсплывающаяПодсказка"
//  style="
//    text-align: center | justify | left | right; // Только для div и p
//    color: #000000 | rgb(,,) | цвет_текстом;
//    background-color: #000000 | rgb(,,) | цвет_текстом | transparent; "
// ></тег>.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//   Строка - строковое представление открывающего тега со всеми установленными атрибутами.
//
Функция ПолучитьПредставлениеАтрибутов()

	Результат = "";
	РезультатСтиля = "";

	Если НЕ ПустаяСтрока(ЭтотОбъект.ФорматВсплывающаяПодсказка) Тогда
		Результат = Результат + " title=""" + ЭтотОбъект.ФорматВсплывающаяПодсказка + """ ";
	КонецЕсли;
	Если ЭтотОбъект.ФорматВыравниваниеАбзацаПоУмолчанию <> Истина Тогда
		Если ЭтотОбъект.ФорматВыравниваниеАбзаца = 1 Тогда // Влево
			РезультатСтиля = РезультатСтиля + "text-align: left; ";
		ИначеЕсли ЭтотОбъект.ФорматВыравниваниеАбзаца = 2 Тогда // Вправо
			РезультатСтиля = РезультатСтиля + "text-align: right; ";
		ИначеЕсли ЭтотОбъект.ФорматВыравниваниеАбзаца = 3 Тогда // По центру
			РезультатСтиля = РезультатСтиля + "text-align: center; ";
		ИначеЕсли ЭтотОбъект.ФорматВыравниваниеАбзаца = 4 Тогда // По ширине
			РезультатСтиля = РезультатСтиля + "text-align: justify; ";
		КонецЕсли;
	КонецЕсли;
	Если ЭтотОбъект.ФорматЦветТекстаПоУмолчанию <> Истина Тогда
		РезультатСтиля = РезультатСтиля
			+ "color: rgb("
				+ ЭтотОбъект.ФорматЦветТекста.Красный + ","
				+ ЭтотОбъект.ФорматЦветТекста.Зеленый + ","
				+ ЭтотОбъект.ФорматЦветТекста.Синий
			+ "); ";
	КонецЕсли;
	Если ЭтотОбъект.ФорматЦветФонаПоУмолчанию <> Истина Тогда
		РезультатСтиля = РезультатСтиля
			+ "background-color: rgb("
				+ ЭтотОбъект.ФорматЦветФона.Красный + ","
				+ ЭтотОбъект.ФорматЦветФона.Зеленый + ","
				+ ЭтотОбъект.ФорматЦветФона.Синий
			+ "); ";
	КонецЕсли;

	Если НЕ ПустаяСтрока(РезультатСтиля) Тогда
		Результат = Результат + " style=""" + РезультатСтиля + """ ";
	КонецЕсли;

	Результат = СтрЗаменить(Результат, ";", "; ");
	Результат = СтрЗаменить(Результат, ":", ": ");
	Результат = СтрЗаменить(Результат, "  ", " ");
	ЭтотОбъект.ТекстАтрибутов = Результат;

	Результат = "<" + НРег(ЭтотОбъект.Тег) + Результат + ">" + ЭтотОбъект.ВыделенныйТекст + "</" + НРег(ЭтотОбъект.Тег) + ">";

	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Процедура управляет видимостью и доступностью элементов управления на форме.
//
// Параметры:
//  лкФорма - эта форма.
//
Процедура УправлениеФормой(лкФорма)

	лкЭлементы = лкФорма.Элементы;

	Если лкФорма.ФорматЦветТекстаПоУмолчанию = Истина Тогда
		лкЭлементы.ДекорацияПримерОформленияЦветом.ЦветТекста = Новый Цвет();
	Иначе
		лкЭлементы.ДекорацияПримерОформленияЦветом.ЦветТекста = лкФорма.ФорматЦветТекста;
	КонецЕсли;

	Если лкФорма.ФорматЦветФонаПоУмолчанию = Истина Тогда
		лкЭлементы.ДекорацияПримерОформленияЦветом.ЦветФона = Новый Цвет();
	Иначе
		лкЭлементы.ДекорацияПримерОформленияЦветом.ЦветФона = лкФорма.ФорматЦветФона;
	КонецЕсли;

	лкЭлементы.ДекорацияПримерОформленияЦветом.Подсказка = лкФорма.ФорматВсплывающаяПодсказка;

	лкЭлементы.КомандаВыравниваниеАбзацаВлево.Пометка    = Ложь;
	лкЭлементы.КомандаВыравниваниеАбзацаВправо.Пометка   = Ложь;
	лкЭлементы.КомандаВыравниваниеАбзацаПоЦентру.Пометка = Ложь;
	лкЭлементы.КомандаВыравниваниеАбзацаПоШирине.Пометка = Ложь;
	Если лкФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь Тогда
		Если лкФорма.ФорматВыравниваниеАбзаца = 1 Тогда
			лкЭлементы.КомандаВыравниваниеАбзацаВлево.Пометка    = Истина;
		ИначеЕсли лкФорма.ФорматВыравниваниеАбзаца = 2 Тогда
			лкЭлементы.КомандаВыравниваниеАбзацаВправо.Пометка   = Истина;
		ИначеЕсли лкФорма.ФорматВыравниваниеАбзаца = 3 Тогда
			лкЭлементы.КомандаВыравниваниеАбзацаПоЦентру.Пометка = Истина;
		ИначеЕсли лкФорма.ФорматВыравниваниеАбзаца = 4 Тогда
			лкЭлементы.КомандаВыравниваниеАбзацаПоШирине.Пометка = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
// Парсит текстовую строку вида:
//<тег
//  title="ВсплывающаяПодсказка"
//  style="
//    text-align: center | justify | left | right; // Только для div и p
//    color: #000000 | rgb(,,) | ЦветТекстом;
//    background-color: #000000 | rgb(,,) | ЦветТекстом | transparent; "
//></тег>
// и преобразует все параметры из текста в значения реквизитов формы.
//
// Параметры:
//  Атрибуты - текстовое представление атрибутов.
//
Процедура РаспарситьАтрибуты(Знач Атрибуты)

	ЭтотОбъект.ФорматВсплывающаяПодсказка          = ""; // title=""
	ЭтотОбъект.ФорматВыравниваниеАбзаца            = 0; // style="text-align:...;"
	ЭтотОбъект.ФорматВыравниваниеАбзацаПоУмолчанию = Истина;
	ЭтотОбъект.ФорматЦветТекста                    = Новый Цвет; // style="color:...;"
	ЭтотОбъект.ФорматЦветТекстаПоУмолчанию         = Истина;
	ЭтотОбъект.ФорматЦветФона                      = Новый Цвет; // style="background-color:...;"
	ЭтотОбъект.ФорматЦветФонаПоУмолчанию           = Истина;

	// Найти title, все что после = и между кавычками - это значение.
	ГдеПодсказка = СтрНайти(ВРег(Атрибуты), ВРег("title"));
	Если ГдеПодсказка > 0 Тогда
		// Последовательно найти =, открывающую ", закрывающую ".
		ГдеРавно = СтрНайти(Прав(Атрибуты, СтрДлина(Атрибуты) - ГдеПодсказка - 5 + 1), "=");
		Если ГдеРавно > 0 Тогда
			ГдеОткрывающаяКавычка = СтрНайти(Сред(Атрибуты, ГдеРавно + 1, СтрДлина(Атрибуты) - ГдеРавно), """");
			Если ГдеОткрывающаяКавычка > 0 Тогда
				ГдеЗакрывающаяКавычка = СтрНайти(Сред(Атрибуты, ГдеОткрывающаяКавычка + 1, СтрДлина(Атрибуты) - ГдеОткрывающаяКавычка), """");
				Если ГдеЗакрывающаяКавычка > 0 Тогда
					ЭтотОбъект.ФорматВсплывающаяПодсказка = Сред(Атрибуты, ГдеОткрывающаяКавычка + 1, ГдеЗакрывающаяКавычка - ГдеОткрывающаяКавычка - 1);
					// Преобразовать атрибуты - убрать из них уже вычисленный title.
					НовыеАтрибуты = "";
					Для С=1 По СтрДлина(Атрибуты) Цикл
						Если С<ГдеПодсказка ИЛИ С>ГдеЗакрывающаяКавычка Тогда
							НовыеАтрибуты = НовыеАтрибуты + Сред(Атрибуты, С, 1);
						КонецЕсли;
					КонецЦикла;
					Атрибуты = НовыеАтрибуты;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// Найти style, все что после = и между кавычками, надо разделить символом ";" - это будет пара ключ:значение.
	ГдеСтиль = СтрНайти(ВРег(Атрибуты), ВРег("style"));
	Если ГдеСтиль > 0 Тогда
		// Последовательно найти =, открывающую ", закрывающую ".
		ГдеРавно = СтрНайти(Прав(Атрибуты, СтрДлина(Атрибуты) - ГдеСтиль - 5 + 1), "=");
		Если ГдеРавно > 0 Тогда
			ГдеОткрывающаяКавычка = СтрНайти(Сред(Атрибуты, ГдеРавно + 1, СтрДлина(Атрибуты) - ГдеРавно), """");
			Если ГдеОткрывающаяКавычка > 0 Тогда
				ГдеЗакрывающаяКавычка = СтрНайти(Сред(Атрибуты, ГдеОткрывающаяКавычка + 1, СтрДлина(Атрибуты) - ГдеОткрывающаяКавычка), """");
				Если ГдеЗакрывающаяКавычка > 0 Тогда
					// Нашли стиль. Все элементы стиля представляют собой ключ:значение и разделены между собой символом ";", например
					// <p style="color: red; text-align: right; ">Текст параграфа</p>.
					ВсеЭлементыСтиля = Сред(Атрибуты, ГдеОткрывающаяКавычка + 1, ГдеЗакрывающаяКавычка - ГдеОткрывающаяКавычка - 1);
					ВсеЭлементыСтиля = СтрЗаменить(ВсеЭлементыСтиля, ";", Символы.ПС);
					Для С1=1 По СтрЧислоСтрок(ВсеЭлементыСтиля) Цикл
						ЭлементСтиля = СтрПолучитьСтроку(ВсеЭлементыСтиля, С1);
						ГдеДвоеточие = СтрНайти(ЭлементСтиля, ":");
						Если ГдеДвоеточие > 0 Тогда
							КлючСтиля = СокрЛП(СтрЗаменить(Лев(ЭлементСтиля, ГдеДвоеточие - 1), " ", ""));
							ЗначениеСтиля = СокрЛП(СтрЗаменить(Прав(ЭлементСтиля, СтрДлина(ЭлементСтиля) - ГдеДвоеточие), " ", ""));
							Если ВРег(КлючСтиля) = ВРег("color") Тогда
								// значение типа rgb(,,) - удалить "rgb(" и ")", а остальное разделить по запятым.
								ЗначениеСтиля = СтрЗаменить(ВРег(ЗначениеСтиля), ВРег("rgb("), "");
								ЗначениеСтиля = СтрЗаменить(ЗначениеСтиля, ")", "");
								ЗначениеСтиля = СтрЗаменить(ЗначениеСтиля, ",", Символы.ПС);
								Если СтрЧислоСтрок(ЗначениеСтиля) >= 3 Тогда
									ЭтотОбъект.ФорматЦветТекста = Новый Цвет(
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 1)),
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 2)),
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 3)));
									ЭтотОбъект.ФорматЦветТекстаПоУмолчанию = Ложь;
								КонецЕсли;
							ИначеЕсли ВРег(КлючСтиля) = ВРег("background-color") Тогда
								// значение типа rgb(,,) - удалить "rgb(" и ")", а остальное разделить по запятым.
								ЗначениеСтиля = СтрЗаменить(ВРег(ЗначениеСтиля), ВРег("rgb("), "");
								ЗначениеСтиля = СтрЗаменить(ЗначениеСтиля, ")", "");
								ЗначениеСтиля = СтрЗаменить(ЗначениеСтиля, ",", Символы.ПС);
								Если СтрЧислоСтрок(ЗначениеСтиля) >= 3 Тогда
									ЭтотОбъект.ФорматЦветФона = Новый Цвет(
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 1)),
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 2)),
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 3)));
									ЭтотОбъект.ФорматЦветФонаПоУмолчанию = Ложь;
								КонецЕсли;
							ИначеЕсли ВРег(КлючСтиля) = ВРег("text-align") Тогда
								Если ВРег(ЗначениеСтиля) = ВРег("left") Тогда
									ЭтотОбъект.ФорматВыравниваниеАбзаца = 1;
									ЭтотОбъект.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
								ИначеЕсли ВРег(ЗначениеСтиля) = ВРег("right") Тогда
									ЭтотОбъект.ФорматВыравниваниеАбзаца = 2;
									ЭтотОбъект.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
								ИначеЕсли ВРег(ЗначениеСтиля) = ВРег("center") Тогда
									ЭтотОбъект.ФорматВыравниваниеАбзаца = 3;
									ЭтотОбъект.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
								ИначеЕсли ВРег(ЗначениеСтиля) = ВРег("justify") Тогда
									ЭтотОбъект.ФорматВыравниваниеАбзаца = 4;
									ЭтотОбъект.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

