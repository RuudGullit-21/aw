///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ЗакрытиеФормы;

&НаКлиенте
Перем РежимПроверки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЛогинПараметр = Параметры.Логин;
	Сервер = Параметры.Сервер;
	ВыборНовойУчетнойЗаписи = Параметры.ВыборНовойУчетнойЗаписи;
	УчетнаяЗапись = Параметры.УчетнаяЗапись;
	//@skip-warning
	НастройкиНовойУчетнойЗаписи = СервисКриптографииDSSКлиентСервер.ПолучитьПолеСтруктуры(Параметры, "НастройкиНовойУчетнойЗаписи", Истина);
	//@skip-warning
	ДополнитьСервера = СервисКриптографииDSSКлиентСервер.ПолучитьПолеСтруктуры(Параметры, "ДополнитьСервера", Истина);
	
	Если Параметры.СписокСерверов <> Неопределено Тогда
		
		СписокСерверов = Параметры.СписокСерверов;
		Для Каждого СтрокаМассива Из СписокСерверов Цикл
			НоваяСтрока = ТаблицаСервисов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаМассива);
		КонецЦикла;	
	
	КонецЕсли;
	
	СписокВыбор.Параметры.УстановитьЗначениеПараметра("ВнутреннийИдентификатор", Сервер);
	
	ИнициализацияДанныхФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗакрытиеФормы = Ложь;
	ВосстановлениеНачато = Ложь;
	РежимПроверки = Ложь;
	
	ИзменитьОформлениеЭлементов();
	Если НастройкиНовойУчетнойЗаписи И ТаблицаСервисов.Количество() = 0 Тогда
		ЗаполнитьТаблицуСерверов();
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбновитьРазмерыФормы", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ЗакрытиеФормы,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИсточникВыбора = "УчетнаяЗапись" Тогда
		ПроверяемыеРеквизиты.Добавить("УчетнаяЗапись");
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
	
	ПроверитьУникальностьЛогина();
	ИзменитьОформлениеЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникВыбораПриИзменении(Элемент)

	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьУчетнуюЗапись(Элементы.СписокВыбор.ТекущаяСтрока);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыборДействияПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подтвердить(Команда)
	
	Если ИсточникВыбора = "УчетнаяЗапись"
		И ВыборДействия = "Восстановить" Тогда
		ПодготовитьВосстановлениеУчетнойЗаписи();
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если ИсточникВыбора = "НовыйЛогин" Тогда
		ЗакрытьФорму(СформироватьРезультат(Истина));
	Иначе
		ВыбратьУчетнуюЗапись(Элементы.СписокВыбор.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОформлениеФормы

&НаКлиенте
Процедура ОбновитьРазмерыФормы()
	
	ИмяЭлемента = "ГруппаСписокВыбораСодержимое";
	
	Элементы[ИмяЭлемента].Видимость = НЕ Элементы[ИмяЭлемента].Видимость;
	Элементы[ИмяЭлемента].Видимость = НЕ Элементы[ИмяЭлемента].Видимость;
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьОшибкаСерверов()
	
	ЕстьОшибка = ТаблицаСервисов.Количество() = 0 И НастройкиНовойУчетнойЗаписи;
	
	Возврат ЕстьОшибка;
	
КонецФункции

&НаКлиенте
Процедура ИзменитьОформлениеЭлементов()
	
	ШаблонОшибки = "<span style=""color: ПоясняющийОшибкуТекст"">%1</span>";
	ПодсказкаСервера = "";
	ПодсказкаЛогина = "";
	
	Если ЕстьОшибкаСерверов() Тогда
		ПодсказкаСервера = СтрШаблон(ШаблонОшибки, НСтр("ru = 'Не удалось получить список доступных серверов DSS.
								|Повторите попытку позже или обратитесь в службу поддержки.'"));
	КонецЕсли;
	
	Если СостояниеЛогина = 1 Тогда
		ПодсказкаЛогина = СтрШаблон(ШаблонОшибки, НСтр("ru = 'Обнаружена учетная запись с таким логином. Выберите другой логин или 
								|восстановите информацию о ней в ИБ.'"));
	ИначеЕсли СостояниеЛогина = 2 Тогда
		ПодсказкаЛогина = СтрШаблон(ШаблонОшибки, НСтр("ru = 'Такая учетная запись уже зарегистрирована в этой ИБ'"));
	КонецЕсли;
	
	Элементы.Логин.РасширеннаяПодсказка.Заголовок = СтроковыеФункцииКлиент.ФорматированнаяСтрока(ПодсказкаЛогина);
	Элементы.Сервер.РасширеннаяПодсказка.Заголовок = СтроковыеФункцииКлиент.ФорматированнаяСтрока(ПодсказкаСервера);
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	
	ЕстьОшибка = ЕстьОшибкаСерверов();
	Редактируется = НЕ РежимПроверки И НЕ ВосстановлениеНачато;
	
	Элементы.Сервер.Видимость = (ТаблицаСервисов.Количество() > 1 ИЛИ ЕстьОшибка);
	Элементы.ГруппаНоваяУчетнаяЗапись.Видимость = ВыборНовойУчетнойЗаписи;
	Элементы.ИсточникВыбораСписок.Видимость = ВыборНовойУчетнойЗаписи;
	Элементы.ВыборДействия.Видимость = НастройкиНовойУчетнойЗаписи;
	Элементы.ГруппаКомандыСпискаВыбора.Видимость = НЕ НастройкиНовойУчетнойЗаписи И НЕ ВыборНовойУчетнойЗаписи;
	Элементы.ГруппаКоманды.Видимость = НастройкиНовойУчетнойЗаписи ИЛИ ВыборНовойУчетнойЗаписи;
	Элементы.ГруппаДействия.ТекущаяСтраница = ?(ВыборДействия = "Список", Элементы.ГруппаСписокВыбора, Элементы.ГруппаСоздатьУчетнуюЗапись);
	
	Элементы.ИсточникВыбораСписок.ТолькоПросмотр = НЕ Редактируется;
	Элементы.ИсточникВыбораНовая.ТолькоПросмотр = НЕ Редактируется;
	Элементы.Логин.ТолькоПросмотр = НЕ Редактируется ИЛИ ЕстьОшибка;
	
	Элементы.Подтвердить.Доступность = Редактируется;
	Элементы.ГруппаКомандыСпискаВыбора.Доступность = Редактируется;
	Элементы.СписокВыбор.Доступность = Редактируется И ИсточникВыбора <> "НовыйЛогин";
	Элементы.ГруппаСоздатьУчетнуюЗапись.Доступность = Редактируется И ИсточникВыбора <> "НовыйЛогин";
	Элементы.ВыборДействия.Доступность = Редактируется И ИсточникВыбора <> "НовыйЛогин";
	
КонецПроцедуры

#КонецОбласти

#Область ДействияФормы

&НаКлиенте
Процедура ЗакрытьФорму(РезультатВыбора = Неопределено)
	
	ЗакрытиеФормы = Истина;
	Если РезультатВыбора = Неопределено Тогда
		РезультатВыбора = СформироватьРезультат(Ложь);
	КонецЕсли;
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьУчетнуюЗапись(ТекущаяУчетнаяЗапись)
	
	УчетнаяЗапись = ТекущаяУчетнаяЗапись;
	ИсточникВыбора = "УчетнаяЗапись";
	ЗакрытьФорму(СформироватьРезультат(Истина, УчетнаяЗапись));
	
КонецПроцедуры	

&НаКлиенте
Функция СформироватьРезультат(Выполнено, ТекущаяУчетнаяЗапись = Неопределено)
	
	Результат = Новый Структура;
	Результат.Вставить("Выполнено", Выполнено);
	
	Если Выполнено Тогда
		НашлиСервер = НайтиСерверОблачнойПодписи(Сервер, "Представление");
		Результат.Вставить("ИсточникВыбора", ИсточникВыбора);
		Результат.Вставить("Логин", ЛогинУчетнойЗаписи);
		Результат.Вставить("Сервер", Сервер);
		Результат.Вставить("СерверПредставление", НашлиСервер);
		Результат.Вставить("УчетнаяЗапись", ТекущаяУчетнаяЗапись);
		Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
			ДанныеСервера = ДанныеУчетнойЗаписи(УчетнаяЗапись);
			Результат.Вставить("СерверПредставление", ДанныеСервера.Представление);
			Результат.Вставить("Логин", ДанныеСервера.Логин);
			Результат.Вставить("Сервер", ДанныеСервера.Сервер);
		КонецЕсли;	
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокСерверов()
	
	Если ДополнитьСервера Тогда
		ВсеСервера = СервисКриптографииDSS.ПолучитьВсеСерверы();
		Для Каждого СтрокаТаблицы Из ВсеСервера Цикл
			Если ЗначениеЗаполнено(СтрокаТаблицы.ВнутреннийИдентификатор) Тогда
				НашлиСтроки = ТаблицаСервисов.НайтиСтроки(Новый Структура("ВнутреннийИдентификатор", СтрокаТаблицы.ВнутреннийИдентификатор));
			Иначе
				НашлиСтроки = ТаблицаСервисов.НайтиСтроки(Новый Структура("Представление", СтрокаТаблицы.Наименование));
			КонецЕсли;
			
			Если НашлиСтроки.Количество() = 0 Тогда
				НоваяСтрока = ТаблицаСервисов.Добавить();
				НоваяСтрока.ВнутреннийИдентификатор = СтрокаТаблицы.Ссылка.УникальныйИдентификатор();
				НоваяСтрока.Представление = СтрокаТаблицы.Наименование;
				НоваяСтрока.ДанныеСервиса = СтрокаТаблицы.Ссылка;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	СписокВыбора = Элементы.Сервер.СписокВыбора;
	
	СписокВыбора.Очистить();
	
	Для Каждого СтрокаМассива Из ТаблицаСервисов Цикл
		СписокВыбора.Добавить(СтрокаМассива.ВнутреннийИдентификатор, СтрокаМассива.Представление);
	КонецЦикла;	
	
	Если ТаблицаСервисов.Количество() = 1 И ПустаяСтрока(Сервер) Тогда
		Сервер = ТаблицаСервисов[0].ВнутреннийИдентификатор;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НайтиСерверОблачнойПодписи(Сервер, "АдресСервера")) Тогда
		Сервер = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияДанныхФормы()
	
	ЗаполнитьСписокСерверов();
	
	ЛогинУчетнойЗаписи = ЛогинПараметр;
	ВосстановлениеНачато = Ложь;
	ВыборДействия = "Список";

	Если ЗначениеЗаполнено(ЛогинУчетнойЗаписи) Тогда
		Элементы.Логин.СписокВыбора.Добавить(ЛогинУчетнойЗаписи);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УчетнаяЗапись) ИЛИ НЕ ВыборНовойУчетнойЗаписи Тогда
		Элементы.СписокВыбор.ТекущаяСтрока = УчетнаяЗапись;
		ИсточникВыбора = "УчетнаяЗапись";
	Иначе
		ИсточникВыбора = "НовыйЛогин";
	КонецЕсли;
	
	Элементы.ГруппаДействия.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
КонецПроцедуры

#КонецОбласти

#Область РежимВосстановления

&НаКлиенте
Процедура ПодготовитьВосстановлениеУчетнойЗаписи()
	
	НашлиУчетку = НайтиУчетнуюЗапись();
	Если ЗначениеЗаполнено(НашлиУчетку) Тогда
		ВыбратьУчетнуюЗапись(НашлиУчетку);
	Иначе
		ПодготовитьВосстановлениеУчетнойЗаписиПослеПроверки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьВосстановлениеУчетнойЗаписиПослеПроверки()
	
	ВосстановлениеНачато = Истина;
	ИзменитьОформлениеЭлементов();
	
	ДанныеСервера = НайтиСерверОблачнойПодписи(Сервер);
	
	ОписаниеСледующее = Новый ОписаниеОповещения("ПодготовитьВосстановлениеУчетнойЗаписиЗавершение", ЭтотОбъект);
	СервисКриптографииDSSКлиент.ВосстановитьУчетнуюЗапись(ОписаниеСледующее, ДанныеСервера, ЛогинУчетнойЗаписи);
		
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьВосстановлениеУчетнойЗаписиЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ВосстановлениеНачато = Ложь;
	ИзменитьОформлениеЭлементов();
	
	Если РезультатВыполнения.Выполнено Тогда
		ВыбратьУчетнуюЗапись(РезультатВыполнения.Результат);
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

#Область РежимСоздания

&НаСервере
Функция СервисРеестраСерверовОблачнойПодписи()
	
	АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	ПараметрыВызова = Новый Структура;
	ПараметрыВызова.Вставить("АдресРезультата", АдресРезультата);
	
	Возврат СервисКриптографииDSSСлужебный.ВыполнитьВФоне("Обработки.УправлениеПодключениемDSS.ОбменССерверомСписокСерверовОблачнойПодписи", ПараметрыВызова);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуСерверов()
	
	ДлительнаяОперация = СервисРеестраСерверовОблачнойПодписи();
	ОповещениеСледущее = Новый ОписаниеОповещения("ЗаполнитьТаблицуСерверовЗавершение", ЭтотОбъект);
	СервисКриптографииDSSСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(ОповещениеСледущее, ДлительнаяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуСерверовЗавершение(ОтветСервиса, ПараметрыЦикла) Экспорт
	
	РезультатВыполнения = СервисКриптографииDSSСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(ОтветСервиса, ПараметрыЦикла);
	Если РезультатВыполнения <> Неопределено Тогда
		
		ЗаполнитьТаблицуФормы(РезультатВыполнения);
		
	КонецЕсли;
	
	ИзменитьОформлениеЭлементов();
	
КонецПроцедуры

// Параметры:
//  СписокСерверов 					- Массив из Структура:
//    * Наименование 				- Строка
//    * ВнутреннийИдентификатор	- Строка
//
&НаКлиенте
Процедура ЗаполнитьТаблицуФормы(СписокСерверов)
	
	Для Каждого СтрокаМассива Из СписокСерверов Цикл
		НоваяСтрока = ТаблицаСервисов.Добавить();
		НоваяСтрока.ДанныеСервиса = СтрокаМассива;
		НоваяСтрока.Представление = СтрокаМассива.Наименование;
		НоваяСтрока.ВнутреннийИдентификатор = СтрокаМассива.ВнутреннийИдентификатор;
	КонецЦикла;	
	
	ЗаполнитьСписокСерверов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьУникальностьЛогина()
	
	НашлиУчетнуюЗапись = НайтиУчетнуюЗапись();
	Если ЗначениеЗаполнено(НашлиУчетнуюЗапись) Тогда
		СостояниеЛогина = 2;
	Иначе
		СостояниеЛогина = 0;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Общие

&НаСервере
Функция НайтиУчетнуюЗапись()
	
	ФильтрПоиска = Новый Соответствие;
	ФильтрПоиска.Вставить("Владелец.ВнутреннийИдентификатор", Сервер);
	ФильтрПоиска.Вставить("Логин", ЛогинУчетнойЗаписи);
	
	НашлиУчетнуюЗапись = СервисКриптографииDSS.НайтиУчетнуюЗапись(ФильтрПоиска);
	
	Возврат НашлиУчетнуюЗапись;
	
КонецФункции

&НаСервере
Функция НайтиСерверОблачнойПодписи(ИдентификаторСервиса, ИмяПоля = "ДанныеСервиса")
	
	Результат = Неопределено;
	
	НашлиСтроки = ТаблицаСервисов.НайтиСтроки(Новый Структура("ВнутреннийИдентификатор", ИдентификаторСервиса));
	Если НашлиСтроки.Количество() <> 0 Тогда
		Если ИмяПоля = "АдресСервера" Тогда
			Результат = НашлиСтроки[0].ДанныеСервиса.АдресСервера;
		ИначеЕсли ИмяПоля = "ДанныеСервиса" Тогда
			Результат = НашлиСтроки[0].ДанныеСервиса;
		ИначеЕсли ИмяПоля = "Представление" Тогда
			Результат = НашлиСтроки[0].Представление;
		КонецЕсли;	
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

&НаСервере
Функция ДанныеУчетнойЗаписи(ТекущаяУчетнаяЗапись)
	
	Результат = Новый Структура;
	Результат.Вставить("Логин", УчетнаяЗапись.Логин);
	Результат.Вставить("Представление", СокрЛП(УчетнаяЗапись.Владелец));
	Результат.Вставить("Сервер", "");
	
	НашлиУчетнуюЗапись = СервисКриптографииDSS.ПолучитьВсеУчетныеЗаписи(ТекущаяУчетнаяЗапись);
	Если НашлиУчетнуюЗапись.Количество() > 0 Тогда
		Результат.Сервер = НашлиУчетнуюЗапись[0].ВнутреннийИдентификатор;
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти