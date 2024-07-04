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
	
	Параметры.Свойство("НастройкиПользователя", НастройкиПользователя);
	
	Если ЗначениеЗаполнено(Параметры.АдресСертификата) Тогда
		ДанныеСертификата = ПолучитьИзВременногоХранилища(Параметры.АдресСертификата);
	КонецЕсли;
	
	СведенияСертификата = Параметры.СведенияСертификата;
	РежимПросмотра = Параметры.РежимПросмотра;
	
	Если ЭтоСертификат(РежимПросмотра) Тогда
		Если ТипЗнч(СведенияСертификата) = Тип("Структура") Тогда
			Отпечаток = СведенияСертификата.Отпечаток;
			ТребуетсяПинКод = СведенияСертификата.ТребуетсяПинКод;
			ДействителенС = СведенияСертификата.ДатаНачала;
			ДействителенПо = СведенияСертификата.ДатаОкончания;
			ПреобразоватьВремя = Истина;
		КонецЕсли;
		
		Если ТипЗнч(ДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
			СертификатОбъект = Новый СертификатКриптографии(ДанныеСертификата);
			ЗаполнитьСведенияСертификатаДвоичныеДанные(СертификатОбъект);
		Иначе
			ЗаполнитьСведенияСертификатаОписание(ДанныеСертификата);
		КонецЕсли;
		
		Если НастройкиПользователя = Неопределено 
			И ЗначениеЗаполнено(Отпечаток) Тогда
			НастройкиПользователя = СервисКриптографииDSSСлужебныйВызовСервера.ПолучитьНастройкиПользователяПоСертификату(Отпечаток);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Отпечаток) Тогда
			ОписаниеСертификата = СервисКриптографииDSSСлужебный.ПолучитьДанныеСертификатаПоОтпечатку(Отпечаток);
			Если ОписаниеСертификата <> Неопределено Тогда
				ИдентификаторОбъекта = ОписаниеСертификата.Идентификатор;
			КонецЕсли;	
		КонецЕсли;
		
	Иначе
		Если ТипЗнч(ДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
			СвойстваЗапросаНаЗапрос = СервисКриптографииDSSASNКлиентСервер.ПолучитьСвойстваЗапросаНаСертификат(ДанныеСертификата);
			ЗаполнитьСведенияЗапросаНаСертификат(СвойстваЗапросаНаЗапрос);
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеФормой();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Проверить(Команда)
	
	Если ТипЗнч(ДанныеСертификата) = Тип("Структура") Тогда
		ОповещениеСледующее = Новый ОписаниеОповещения("ПроверитьПослеПолученияДанных", ЭтотОбъект);
		ПараметрыОперации = Новый Структура();
		ПараметрыОперации.Вставить("ИдентификаторОперации", УникальныйИдентификатор);
		СервисКриптографииDSSКлиент.ПолучитьДанныеСертификата(ОповещениеСледующее, НастройкиПользователя, ИдентификаторОбъекта, ПараметрыОперации);
	Иначе
		ПараметрыВызова = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию();
		ПараметрыВызова.Вставить("Результат", ДанныеСертификата);
		ПроверитьПослеПолученияДанных(ПараметрыВызова, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьПинКод(Команда)
	
	ОписаниеСледующее = Новый ОписаниеОповещения("ПослеСменыПинКода", ЭтотОбъект);
	СервисКриптографииDSSКлиент.СменитьПинКодСертификата(ОписаниеСледующее, НастройкиПользователя, ИдентификаторОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСертификат(Команда)
	
	Если ЭтоСертификат(РежимПросмотра) Тогда
		Если ТипЗнч(ДанныеСертификата) = Тип("Структура") Тогда
			ОповещениеСледующее = Новый ОписаниеОповещения("СкопироватьСертификатПослеПолученияДанных", ЭтотОбъект);
			СервисКриптографииDSSКлиент.ПолучитьДанныеСертификата(ОповещениеСледующее, НастройкиПользователя, ИдентификаторОбъекта);
		Иначе
			ПараметрыВызова = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию();
			ПараметрыВызова.Вставить("Результат", ДанныеСертификата);
			СкопироватьСертификатПослеПолученияДанных(ПараметрыВызова, Неопределено);
		КонецЕсли;
	Иначе
		ОповещениеСледующее = Новый ОписаниеОповещения("СкопироватьСертификатПослеЭкспортаСертификата", ЭтотОбъект);
		СервисКриптографииDSSКлиент.СохранитьДанныеВФайл(ОповещениеСледующее, ДанныеСертификата, ".p10", Истина);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область АсинхронныеВызовы

&НаКлиенте
Процедура ПроверитьПослеПолученияДанных(РезультатВызова, ВходящийКонтекст) Экспорт
	
	Если РезультатВызова.Выполнено Тогда
		ОповещениеСледующее = Новый ОписаниеОповещения("ПроверитьЗавершение", ЭтотОбъект);
		ПараметрыОперации = Новый Структура();
		ПараметрыОперации.Вставить("ИдентификаторОперации", УникальныйИдентификатор);
		СервисКриптографииDSSКлиент.ПроверитьСертификат(ОповещениеСледующее, НастройкиПользователя, РезультатВызова.Результат.Сертификат, ПараметрыОперации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено
		И Результат.Результат Тогда
		СервисКриптографииDSSКлиент.ВывестиИнформацию(Неопределено, 
									НСтр("ru = 'Сертификат действителен'", СервисКриптографииDSSСлужебныйКлиент.КодЯзыка()));
	Иначе
		СервисКриптографииDSSКлиент.ВывестиОшибку(Неопределено, Результат.Ошибка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСертификатПослеПолученияДанных(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	Если РезультатВызова.Выполнено Тогда
		ОповещениеСледующее = Новый ОписаниеОповещения("СкопироватьСертификатПослеЭкспортаСертификата", ЭтотОбъект);
		СервисКриптографииDSSКлиент.СохранитьДанныеВФайл(ОповещениеСледующее, РезультатВызова.Результат.Сертификат, ".cer", Истина);
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура СкопироватьСертификатПослеЭкспортаСертификата(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	ЗадатьВопрос = РезультатВызова.Выполнено;
	
	Если НЕ ЗадатьВопрос Тогда
		СервисКриптографииDSSКлиент.ВывестиОшибку(Неопределено, РезультатВызова.Ошибка);
	КонецЕсли;

	Если ЗадатьВопрос И ЭтоСертификат(РежимПросмотра) Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяФайла", РезультатВызова.Результат);
		ОповещениеСледующее = Новый ОписаниеОповещения("ОткрытьСертификатПослеЭкспортаСертификата", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОповещениеСледующее, 
				НСтр("ru = 'Открыть сертификат на просмотр?'", СервисКриптографииDSSСлужебныйКлиент.КодЯзыка()),
				РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификатПослеЭкспортаСертификата(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		СервисКриптографииDSSКлиент.ПерейтиПоСсылке(ДополнительныеПараметры.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСменыПинКода(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	Если РезультатВызова.Выполнено Тогда
		СервисКриптографииDSSКлиент.ВывестиИнформацию(Неопределено, 
				НСтр("ru = 'Смена пин-кода выполнена успешно.'", СервисКриптографииDSSСлужебныйКлиент.КодЯзыка()), 30);
	Иначе
		СервисКриптографииDSSКлиент.ВывестиОшибку(Неопределено, РезультатВызова.Ошибка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура УправлениеФормой()
	
	ЭлементыФормы = Элементы;
	
	Если ЭтоСертификат(РежимПросмотра) Тогда
		Заголовок = НСтр("ru = 'Сертификат'; en = 'Certificate'");
		ЭлементыФормы.ГруппаПинКод.Видимость = ТребуетсяПинКод;
	Иначе
		Заголовок = НСтр("ru = 'Запрос на сертификат'");
		ЭлементыФормы.ГруппаПинКод.Видимость = Ложь;
		ЭлементыФормы.Проверить.Видимость = Ложь;
		ЭлементыФормы.ГруппаПрочее.Видимость = Ложь;
		ЭлементыФормы.КомуВыдан.Заголовок = НСтр("ru = 'Владелец'; en = 'Owner'");
	КонецЕсли;	
	
	ТекущийЭлемент = Элементы.ФормаЗакрыть;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьСведенияСертификатаДвоичныеДанные(Сертификат)
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	
	// заполняем таблицу всех свойств сертификата
	ТаблицаСостава.Очистить();
	Отпечаток = Сертификат.Отпечаток;
	
	ПредставлениеИздателя = ПолучитьПредставлениеКоллекции(Сертификат.Издатель);
	ПредставлениеСубъекта = ПолучитьПредставлениеКоллекции(Сертификат.Субъект);
	
	КомуВыдан = ПредставлениеСубъекта.Имя;
	КемВыдан = ПредставлениеИздателя.Имя;
	Если НЕ ЗначениеЗаполнено(ДействителенС) Тогда
		ДействителенС = Сертификат.ДатаНачала;
		ДействителенПо = Сертификат.ДатаОкончания;
		ПреобразоватьВремя = Истина;
	КонецЕсли;	
	
	ДобавитьСтроку(НСтр("ru = 'Версия'; en = 'Version'", КодЯзыка), Сертификат.Версия, 2);
	ДобавитьСтроку(НСтр("ru = 'Серийный номер'; en = 'Serial number'", КодЯзыка), ПолучитьHexСтрокуИзДвоичныхДанных(Сертификат.СерийныйНомер), 2);
	ДобавитьСтроку(НСтр("ru = 'Алгоритм подписи'; en = 'Signature algorithm'", КодЯзыка), "неопределено", 2);
	ДобавитьСтроку(НСтр("ru = 'Хеш-алгоритм подписи'", КодЯзыка), "неопределено", 2);
	ДобавитьСтроку(НСтр("ru = 'Издатель'; en = 'Publisher'", КодЯзыка), ПредставлениеИздателя.Поля, 2);
	ДобавитьСтроку(НСтр("ru = 'Субъект'; en = 'Subject'", КодЯзыка), ПредставлениеСубъекта.Поля, 2);
	ДобавитьСтроку(НСтр("ru = 'Открытый ключ'; en = 'Public key'", КодЯзыка), Сертификат.ОткрытыйКлюч, 2);
	ДобавитьСтроку(НСтр("ru = 'Параметры открытого ключа'", КодЯзыка), "неопределено", 2);
	
	Для каждого СтрокаКлюча Из Сертификат.РасширенныеСвойства Цикл
		
		ПредставлениеКлюча = ПолучитьПредставлениеКоллекции(СтрокаКлюча.Значение);
		ДобавитьСтроку(НСтр("ru = 'Улучшенный ключ'", КодЯзыка), ПредставлениеКлюча.Поля, 2);
		
	КонецЦикла;
	
	ПреобразоватьВремя(ПреобразоватьВремя);
	
КонецПроцедуры

&НаСервере
Функция РазделитьНаСтроки(ДанныеСтроки)
	
	Результат = СтрЗаменить(ДанныеСтроки, ",", Символы.ПС);
	Возврат Результат;

КонецФункции

&НаСервере
Процедура ЗаполнитьСведенияСертификатаОписание(Сертификат)
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	
	// заполняем таблицу всех свойств сертификата
	ТаблицаСостава.Очистить();
	
	ПредставлениеИздателя = ПолучитьПредставлениеКоллекции(Сертификат.Издатель);
	ПредставлениеСубъекта = ПолучитьПредставлениеКоллекции(Сертификат.Субъект);
	
	КомуВыдан = ПредставлениеСубъекта.Имя;
	КемВыдан = ПредставлениеИздателя.Имя;
	Если НЕ ЗначениеЗаполнено(ДействителенС) Тогда
		ДействителенС = Сертификат.ДатаНачала;
		ДействителенПо = Сертификат.ДатаОкончания;
	КонецЕсли;	
	
	ДобавитьСтроку(НСтр("ru = 'Версия'; en = 'Version'", КодЯзыка), Сертификат.Версия, 2);
	ДобавитьСтроку(НСтр("ru = 'Серийный номер'; en = 'Serial number'", КодЯзыка), Сертификат.СерийныйНомер, 2);
	ДобавитьСтроку(НСтр("ru = 'Алгоритм подписи'; en = 'Signature algorithm'", КодЯзыка), Сертификат.АлгоритмПодписи, 2);
	ДобавитьСтроку(НСтр("ru = 'Хеш-алгоритм подписи'", КодЯзыка), Сертификат.АлгоритмОткрытогоКлюча, 2);
	ДобавитьСтроку(НСтр("ru = 'Издатель'; en = 'Publisher'", КодЯзыка), ПредставлениеИздателя.Поля, 2);
	ДобавитьСтроку(НСтр("ru = 'Субъект'; en = 'Subject'", КодЯзыка), ПредставлениеСубъекта.Поля, 2);
	ДобавитьСтроку(НСтр("ru = 'Открытый ключ'; en = 'Public key'", КодЯзыка), Сертификат.ОткрытыйКлюч, 2);
	ДобавитьСтроку(НСтр("ru = 'Параметры открытого ключа'", КодЯзыка), Сертификат.ПараметрыОткрытогоКлюча, 2);
	
	Для каждого СтрокаКлюча Из Сертификат.РасширениеСертификата Цикл
		ДобавитьСтроку(СтрокаКлюча.Ключ, РазделитьНаСтроки(СтрокаКлюча.Значение), 2);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСведенияЗапросаНаСертификат(ЗапросНаСертификат)
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	
	// заполняем таблицу всех свойств запроса
	ТаблицаСостава.Очистить();
	
	ПредставлениеСубъекта = ПолучитьПредставлениеКоллекции(ЗапросНаСертификат.Владелец);
	КомуВыдан = ПредставлениеСубъекта.Имя;
	
	ДобавитьСтроку(НСтр("ru = 'Алгоритм ключа'", КодЯзыка), ЗапросНаСертификат.АлгоритмПубличногоКлюча, 2);
	ДобавитьСтроку(НСтр("ru = 'Открытый ключ'; en = 'Public key'", КодЯзыка), ЗапросНаСертификат.ОткрытыйКлюч, 2);
	
	Для каждого СтрокаКлюча Из ЗапросНаСертификат.Владелец Цикл
		ДобавитьСтроку(СтрокаКлюча.Ключ, РазделитьНаСтроки(СтрокаКлюча.Значение), 2);
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура ПреобразоватьВремя(ПреобразоватьВремя)
	
	Если ПреобразоватьВремя Тогда
		ДействителенС = МестноеВремя(ДействителенС);
		ДействителенПо = МестноеВремя(ДействителенПо);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтроку(ПредставлениеПоля, ЗначениеПоля, ТипПоля)
	
	НоваяСтрока = ТаблицаСостава.Добавить();
	НоваяСтрока.Представление = ПредставлениеПоля;
	НоваяСтрока.Значение = ЗначениеПоля;
	НоваяСтрока.Картинка = ТипПоля;
	
КонецПроцедуры

// Формирует список допустимых полей для сертификата
//
// Возвращаемое значение:
//   см. СервисКриптографииDSSASNКлиентСервер.ОпределитьТип_OID
//
&НаСервере
Функция ПоляИдентификаторов()
	
	Результат = СервисКриптографииDSSASNКлиентСервер.ОпределитьТип_OID(Неопределено, "10");
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьПредставлениеКоллекции(КоллекцияДляОбработки)
	
	Результат 	= Новый Структура("Поля, Имя", "", "");
	ВсеПоля 	= ПоляИдентификаторов();
	ИмяОбщее	= "";
	МассивКлючей= Новый Соответствие;
	
	Для каждого СтрокаКоллекции Из КоллекцияДляОбработки Цикл
		Если ТипЗнч(СтрокаКоллекции) = Тип("КлючИЗначение") Тогда
			ПредставлениеКлюча = СтрЗаменить(СтрокаКоллекции.Ключ, "OID", "");
			ПредставлениеКлюча = СтрЗаменить(ПредставлениеКлюча, "_", ".");
			Если ВсеПоля[ПредставлениеКлюча] <> Неопределено Тогда
				ПредставлениеКлюча = ВсеПоля[ПредставлениеКлюча].Имя;
			КонецЕсли;
			МассивКлючей.Вставить(ПредставлениеКлюча, СтрокаКоллекции.Значение);
			Если ПредставлениеКлюча = "CN" ИЛИ ПредставлениеКлюча = "ОбщееИмя" Тогда
				ИмяОбщее = СтрокаКоллекции.Значение;
			КонецЕсли;	
		Иначе
			МассивКлючей.Вставить(СтрокаКоллекции);
			Если ПустаяСтрока(ИмяОбщее) Тогда
				ИмяОбщее = СтрокаКоллекции;
			КонецЕсли;	
		КонецЕсли;
		
	КонецЦикла;	
	
	Результат.Имя = ИмяОбщее;
	
	Для каждого СтрокаКоллекции Из МассивКлючей Цикл
		Результат.Поля = Результат.Поля + ?(ПустаяСтрока(Результат.Поля), "", Символы.ПС);
		Если ЗначениеЗаполнено(СтрокаКоллекции.Значение) Тогда
			Результат.Поля = Результат.Поля + СтрокаКоллекции.Ключ + " = " + СтрокаКоллекции.Значение;
		Иначе
			Результат.Поля = Результат.Поля + СтрокаКоллекции.Ключ;
		КонецЕсли;
		
	КонецЦикла;	
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоСертификат(РежимПросмотра)
	
	Результат = РежимПросмотра = "Сертификат";
	Возврат Результат;
	
КонецФункции	

#КонецОбласти

#КонецОбласти