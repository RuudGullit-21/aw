///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ИнтернетПоддержкаПользователей.РаботаСКлассификаторами

// См. РаботаСКлассификаторамиПереопределяемый.ПриДобавленииКлассификаторов
Процедура ПриДобавленииКлассификаторов(Классификаторы) Экспорт
	
	Описание = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКлассификаторами") Тогда
		МодульРаботаСКлассификаторами = ОбщегоНазначения.ОбщийМодуль("РаботаСКлассификаторами");
		Описание = МодульРаботаСКлассификаторами.ОписаниеКлассификатора();
	КонецЕсли;
	Если Описание = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Описание.Идентификатор = ИдентификаторКлассификатора();
	Описание.Наименование = НСтр("ru = 'Общероссийский классификатор валют'; en = 'All-Russian Classifier of Currencies'");
	Описание.ОбновлятьАвтоматически = Истина;
	Описание.ОбщиеДанные = Истина;
	Описание.ОбработкаРазделенныхДанных = Ложь;
	Описание.СохранятьФайлВКэш = Истина;
	
	Классификаторы.Добавить(Описание);
	
КонецПроцедуры

// См. РаботаСКлассификаторамиПереопределяемый.ПриЗагрузкеКлассификатора.
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры) Экспорт
	
	Если Идентификатор <> ИдентификаторКлассификатора() Тогда
		Возврат;
	КонецЕсли;
	
	Обработан = Истина;
	
КонецПроцедуры

// Конец ИнтернетПоддержкаПользователей.РаботаСКлассификаторами

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет в справочник валют валюты из классификатора.
//
// Параметры:
//   Коды - Массив - цифровые коды добавляемых валют.
//
// Возвращаемое значение:
//   Массив, СправочникСсылка.Валюты - ссылки созданных валют.
//
Функция ДобавитьВалютыПоКоду(Знач Коды) Экспорт
	
	Результат = Новый Массив;
	КлассификаторТаблица = КлассификаторВалют();

	Для каждого Код Из Коды Цикл
		ЗаписьОКВ = КлассификаторТаблица.Найти(Код, "Code"); 
		Если ЗаписьОКВ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ВалютаСсылка = Справочники.Валюты.НайтиПоКоду(ЗаписьОКВ.Code);
		Если ВалютаСсылка.Пустая() Тогда
			НоваяСтрока = Справочники.Валюты.СоздатьЭлемент();
			НоваяСтрока.Код = ЗаписьОКВ.Code;
			НоваяСтрока.Наименование = ЗаписьОКВ.CodeSymbol;
			НоваяСтрока.НаименованиеПолное = ЗаписьОКВ.Name;
			Если ЗаписьОКВ.RBCLoading Тогда
				НоваяСтрока.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
			Иначе
				НоваяСтрока.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
			КонецЕсли;
			НоваяСтрока.ПараметрыПрописи = ЗаписьОКВ.NumerationItemOptions;
			НоваяСтрока.Записать();
			Результат.Добавить(НоваяСтрока.Ссылка);
		Иначе
			Результат.Добавить(ВалютаСсылка);
		КонецЕсли
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

// Загружает курсы валют на текущую дату.
//
// Параметры:
//  ПараметрыЗагрузки - Структура:
//   * НачалоПериода - Дата - начало периода загрузки;
//   * КонецПериода - Дата - конец периода загрузки;
//   * СписокВалют - ТаблицаЗначений:
//     ** Валюта - СправочникСсылка.Валюты
//     ** КодВалюты - Строка
//  АдресРезультата - Строка - адрес во временном хранилище для помещения результатов загрузки.
//
Процедура ЗагрузитьАктуальныйКурс(ПараметрыЗагрузки = Неопределено, АдресРезультата = Неопределено) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют);
	
	ИмяСобытия = ИмяСобытияЖурналаРегистрации();
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Информация, , ,
		НСтр("ru = 'Начата регламентная загрузка курсов валют'; en = 'Scheduled import of exchange rates is started'"));
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	ПриЗагрузкеВозниклиОшибки = Ложь;
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КурсыВалют.Валюта КАК Валюта,
		|	КурсыВалют.Валюта.Код КАК КодВалюты,
		|	МАКСИМУМ(КурсыВалют.Период) КАК ДатаКурса
		|ИЗ
		|	РегистрСведений.КурсыВалют КАК КурсыВалют
		|ГДЕ
		|	КурсыВалют.Валюта.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
		|	И НЕ КурсыВалют.Валюта.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	КурсыВалют.Валюта,
		|	КурсыВалют.Валюта.Код";
		Запрос = Новый Запрос(ТекстЗапроса);
		Выборка = Запрос.Выполнить().Выбрать();
		
		КонецПериода = ТекущаяДата;
		Пока Выборка.Следующий() Цикл
			НачалоПериода = ?(Выборка.ДатаКурса = '198001010000', НачалоГода(ДобавитьМесяц(ТекущаяДата, -12)), Выборка.ДатаКурса + 60*60*24);
			СписокВалют = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Выборка);
			ЗагрузитьКурсыВалютПоПараметрам(СписокВалют, НачалоПериода, КонецПериода, ПриЗагрузкеВозниклиОшибки);
		КонецЦикла;
	Иначе
		Результат = ЗагрузитьКурсыВалютПоПараметрам(ПараметрыЗагрузки.СписокВалют,
			ПараметрыЗагрузки.НачалоПериода, ПараметрыЗагрузки.КонецПериода, ПриЗагрузкеВозниклиОшибки);
	КонецЕсли;
		
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;

	Если ПриЗагрузкеВозниклиОшибки Тогда
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,,
			НСтр("ru = 'Во время регламентной загрузки курсов валют возникли ошибки'"));
		Если ПараметрыЗагрузки = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Загрузка курсов не выполнена.'; en = 'Download of the courses not completed.'");
		КонецЕсли;
	Иначе
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Информация,,,
			НСтр("ru = 'Завершена регламентная загрузка курсов валют.'; en = 'Scheduled download of exchange rates is completed.'"));
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список разрешений для загрузки классификатора банков с сайта 1С.
//
// Параметры:
//  Разрешения - Массив - коллекция разрешений.
//
Процедура ДобавитьРазрешения(Разрешения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАльтернативныйСервер = Константы.ИспользоватьАльтернативныйСерверДляЗагрузкиКурсовВалют.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Если ИспользоватьАльтернативныйСервер Тогда
		Протокол = "HTTP";
		Адрес = "cbrates.rbc.ru";
		Порт = Неопределено;
		Описание = НСтр("ru = 'Загрузка курсов валют с сайта РБК.'; en = 'Currency exchange rates download from the RBC site.'");
		Разрешения.Добавить( 
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	Иначе
		Протокол = "HTTPS";
		Адрес = "currencyrates.1c.ru";
		Порт = Неопределено;
		Описание = НСтр("ru = 'Загрузка курсов валют с сайта 1С.'; en = 'Download currency exchange rates from site 1C.'");
		Разрешения.Добавить( 
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	КонецЕсли;
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.4.1.1";
	Обработчик.Процедура = "Обработки.ЗагрузкаКурсовВалют.ОтключитьЗагрузкуКурсаВалюты643ИзИнтернета";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("dc79c561-8657-4852-bbc5-38ced6996fff");
	Обработчик.Комментарий = НСтр("ru = 'Отключает ошибочно включенную загрузку курсов валюты ""Российский рубль (643)"" из интернета.'; en = 'Disables mistakenly included download of courses of currency ""Russian ruble (643)"" from the Internet.'");
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Обработки.ЗагрузкаКурсовВалют.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ЧитаемыеОбъекты      = "Справочник.Валюты";
	Обработчик.ИзменяемыеОбъекты    = "Справочник.Валюты";
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "2.4.1.1";
		Обработчик.Процедура = "Обработки.ЗагрузкаКурсовВалют.УстановитьРасписаниеРегламентногоЗадания";
		Обработчик.РежимВыполнения = "Оперативно";
		Обработчик.НачальноеЗаполнение = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
// Параметры:
//  Параметры - Структура - служебный параметр для передачи в процедуру ОбновлениеИнформационнойБазы.ОтметитьКОбработке.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Код = ""643""
	|	И Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	Зависимость = Настройки.Добавить();
	Зависимость.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют;
	Зависимость.ДоступноВМоделиСервиса = Ложь;
	Зависимость.ДоступноВАвтономномРабочемМесте = Ложь;
КонецПроцедуры

// Процедура для загрузки курсов валют по определенному периоду.
//
// Параметры:
//   Валюты		- Массив из Структура:
//    * КодВалюты - Число - числовой код валюты.
//    * Валюта - СправочникСсылка.Валюты
//   НачалоПериодаЗагрузки	- Дата - начало периода загрузки курсов.
//   ОкончаниеПериодаЗагрузки	- Дата - окончание периода загрузки курсов.
//
// Возвращаемое значение:
//   Массив из Структура:
//    Валюта - СправочникСсылка.Валюты - загружаемая валюта.
//    СтатусОперации - Булево - завершилась ли загрузка успешно.
//    Сообщение - Строка - текст сообщения об ошибке или поясняющее сообщение.
//
Функция ЗагрузитьКурсыВалютПоПараметрам(Знач Валюты, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки, ПриЗагрузкеВозниклиОшибки = Ложь)
	
	СостояниеЗагрузки = Новый Массив;
	
	ПараметрыПолучения = Неопределено;
	ИмяФайлаДневногоКурса = Формат(ОкончаниеПериодаЗагрузки, "ДФ=/yyyy/MM/dd");
	
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАльтернативныйСервер = Константы.ИспользоватьАльтернативныйСерверДляЗагрузкиКурсовВалют.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ИспользоватьАльтернативныйСервер Тогда
		СерверИсточник = "http://cbrates.rbc.ru";
		Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
			ШаблонИмениФайла = СерверИсточник + "/tsv/%1" + ИмяФайлаДневногоКурса + ".tsv";
		Иначе
			ШаблонИмениФайла = СерверИсточник + "/tsv/cb/%1.tsv";
		КонецЕсли;
	Иначе
		СерверИсточник = "https://currencyrates.1c.ru/exchangerate/v1";
		Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
			ШаблонИмениФайла = СерверИсточник + "/%1" + ИмяФайлаДневногоКурса + ".tsv";
		Иначе
			ШаблонИмениФайла = СерверИсточник + "/%1.tsv";
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		ПараметрыПолучения = ПараметрыАутентификацииНаСайте();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ВалютыЗагружаемыеИзИнтернета = ВалютыЗагружаемыеИзИнтернета();
	
	Для Каждого Валюта Из Валюты Цикл
		Если ВалютыЗагружаемыеИзИнтернета.Найти(Валюта.Валюта) = Неопределено Тогда
			ПриЗагрузкеВозниклиОшибки = Истина;
			СтатусОперации = Ложь;
			ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно получить файл данных с курсами валюты %2 (код %1):
					|Курсы данной валюты не предоставляются.'"),
				Валюта.КодВалюты,
				Валюта.Валюта);
				
			ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , , ПоясняющееСообщение);
		Иначе
			ФайлНаВебСервере = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайла, Валюта.КодВалюты);
			Результат = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлНаВебСервере, ПараметрыПолучения);
			
			Если Результат.Статус Тогда
				ПоясняющееСообщение = ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, Результат.Путь, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
				УдалитьФайлы(Результат.Путь);
				СтатусОперации = ПустаяСтрока(ПоясняющееСообщение);
			Иначе
				Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки И НачалоПериодаЗагрузки > ТекущаяДатаСеанса() Тогда
					ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось загрузить курс валюты %2 (код %1) на %3.
							|Курсы валют на будущие даты не предоставляются.
							|Доступны курсы на текущую дату и история курсов.'"),
						Валюта.КодВалюты,
						Валюта.Валюта,
						Формат(НачалоПериодаЗагрузки, "ДЛФ=D;"));
				Иначе
					ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Невозможно получить файл данных с курсами валюты %2 (код %1):
							|%3
							|Возможно, нет доступа к веб-сайту с курсами валют, либо указана несуществующая валюта.'"),
						Валюта.КодВалюты,
						Валюта.Валюта,
						Результат.СообщениеОбОшибке);
				КонецЕсли;
				СтатусОперации = Ложь;
				ПриЗагрузкеВозниклиОшибки = Истина;
			КонецЕсли;
		КонецЕсли;
		СостояниеЗагрузки.Добавить(Новый Структура("Валюта,СтатусОперации,Сообщение", Валюта.Валюта, СтатусОперации, ПоясняющееСообщение));
		
	КонецЦикла;
	
	Возврат СостояниеЗагрузки;
	
КонецФункции

// Загружает информацию о курсе валюты Валюта из файла ПутьКФайлу в регистр
// сведений курсов валют. При этом файл с курсами разбирается, и записываются
// только те данные, которые удовлетворяют периоду (НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки).
//
Функция ЗагрузитьКурсВалютыИзФайла(Знач Валюта, Знач ПутьКФайлу, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки)
	
	ЧислоЗагружаемыхДнейВсего = 1 + (ОкончаниеПериодаЗагрузки - НачалоПериодаЗагрузки) / ( 24 * 60 * 60);
	
	ЧислоЗагруженныхДней = 0;
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла();
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПутьКФайлу); // ДвоичныеДанные
		ДвоичныеДанные.Записать(ИмяФайла);
	Иначе
		ИмяФайла = ПутьКФайлу;
	КонецЕсли;
	
	Текст = Новый ТекстовыйДокумент();
	Текст.Прочитать(ИмяФайла, КодировкаТекста.ANSI);
	
	ЗагружаемыеДаты = Новый Соответствие;
	
	ДатаЗапрета = Неопределено;
	Для НомерСтроки = 1 По Текст.КоличествоСтрок() Цикл
		
		Стр = Текст.ПолучитьСтроку(НомерСтроки);
		Если (Стр = "") ИЛИ (СтрНайти(Стр, Символы.Таб) = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		ЧастиСтроки = СтрРазделить(Стр, Символы.Таб, Истина);
		
		Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
			ДатаКурса = ОкончаниеПериодаЗагрузки;
			Кратность = Число(ЧастиСтроки[0]);
			Курс = КурсИзСтроки(ЧастиСтроки[1]);
		Иначе
			ДатаКурсаСтр = ЧастиСтроки[0];
			ДатаКурса = Дата(Лев(ДатаКурсаСтр,4), Сред(ДатаКурсаСтр,5,2), Сред(ДатаКурсаСтр,7,2));
			Кратность = Число(ЧастиСтроки[1]);
			Курс = КурсИзСтроки(ЧастиСтроки[2]);
		КонецЕсли;
		
		Если ДатаКурса > ОкончаниеПериодаЗагрузки Тогда
			Прервать;
		КонецЕсли;
		
		Если ДатаКурса < НачалоПериодаЗагрузки Тогда 
			Продолжить;
		КонецЕсли;
		
		ЗагружаемыеДаты.Вставить(ДатаКурса, Истина);
		
		НаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Валюта.Установить(Валюта);
		НаборЗаписей.Отбор.Период.Установить(ДатаКурса);
		Запись = НаборЗаписей.Добавить();
		Запись.Валюта = Валюта;
		Запись.Период = ДатаКурса;
		Запись.Курс = Курс;
		Запись.Кратность = Кратность;
		
		Записывать = Истина;
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
			МодульДатыЗапретаИзмененияСлужебный = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзмененияСлужебный");
			Если МодульДатыЗапретаИзмененияСлужебный.ЗапретИзмененияПроверяется(Метаданные.РегистрыСведений.КурсыВалют) Тогда
				МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
				Записывать = Не МодульДатыЗапретаИзменения.ИзменениеЗапрещено(НаборЗаписей);
				Если Не Записывать Тогда
					Если ДатаЗапрета = Неопределено Тогда
						ДатаЗапрета = ДатаКурса;
					Иначе
						ДатаЗапрета = Макс(ДатаЗапрета, ДатаКурса);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Записывать Тогда
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЧислоЗагруженныхДней = ЧислоЗагруженныхДней + 1;
	КонецЦикла;
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		УдалитьФайлы(ИмяФайла);
		УдалитьИзВременногоХранилища(ПутьКФайлу);
	КонецЕсли;
	
	ПояснениеОЗагрузке = "";
	Если ЧислоЗагружаемыхДнейВсего <> ЧислоЗагруженныхДней Тогда
		Если ЧислоЗагруженныхДней = 0 Тогда
			ПояснениеОЗагрузке = НСтр("ru = 'Курсы валюты %1 (%2) не загружены.
				|Нет сведений о курсе за указанный период.'");
		Иначе
			ПропущенныеДаты = Новый Массив;
			
			КоличествоСекундВСутках = 24 * 60 * 60;
			Для Индекс = 0 По ЧислоЗагружаемыхДнейВсего - 1 Цикл
				Дата = ОкончаниеПериодаЗагрузки - Индекс * КоличествоСекундВСутках;
				Если ЗагружаемыеДаты[Дата] <> Истина Тогда
					ПропущенныеДаты.Добавить(Формат(Дата, "ДЛФ=D;"));
				КонецЕсли;
			КонецЦикла;
			
			ПояснениеОЗагрузке = НСтр("ru = 'Загружены не все курсы по валюте %1 (%2).'; en = 'Not all exchange rates for currency %1 are imported (%2).'") + Символы.ПС 
				+  ПояснениеПоПропущеннымДатам(ПропущенныеДаты);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ПояснениеОЗагрузке) Тогда
		ПояснениеОЗагрузке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПояснениеОЗагрузке, Валюта.Наименование, Валюта.Код);
	КонецЕсли;
	
	Если ДатаЗапрета <> Неопределено Тогда
		ПояснениеОЗагрузке = ПояснениеОЗагрузке + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Загрузка курсов валюты %1(%2) ограничена датой запрета изменений %3."
"Курсы запрещенного периода были пропущены при загрузке.'; en = 'Importing of exchange rates %1(%2) is limited by change prohibition date %3."
"Rates of the prohibited period were skipped during import.'"), Валюта.Наименование, Валюта.Код, Формат(ДатаЗапрета, "ДЛФ=D"));
	КонецЕсли;
	
	ПояснениеОЗагрузке = СокрЛП(ПояснениеОЗагрузке);
	
	СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
	СписокОшибок = Новый Массив;
	Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл
		СписокОшибок.Добавить(СообщениеПользователю.Текст);
	КонецЦикла;
	СписокОшибок = ОбщегоНазначенияКлиентСервер.СвернутьМассив(СписокОшибок);
	ПояснениеОЗагрузке = ПояснениеОЗагрузке + ?(ПустаяСтрока(ПояснениеОЗагрузке), "", Символы.ПС) + СтрСоединить(СписокОшибок, Символы.ПС);
	
	Возврат ПояснениеОЗагрузке;
	
КонецФункции

Функция ПояснениеПоПропущеннымДатам(ПропущенныеДаты);
	
	Результат = "";
	
	Если ПропущенныеДаты.Количество() = 1 Тогда
		Результат =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отсутствует курс на %1.'"), СтрСоединить(ПропущенныеДаты));
	ИначеЕсли ПропущенныеДаты.Количество() <=5 Тогда
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отсутствуют курсы на %1.'"), СтрСоединить(ПропущенныеДаты, ", "));
	Иначе 
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отсутствуют курсы на %1, %2, %3 и другие даты (всего %4).'"), 
			ПропущенныеДаты[0],
			ПропущенныеДаты[1],
			ПропущенныеДаты[2],
			ПропущенныеДаты.Количество());
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Предназначена для преобразования формата чисел, используемого в файле курсов валюты.
// Работает в любой локализации, не поддерживает отрицательные числа.
//
Функция КурсИзСтроки(Знач Строка)
	
	Строка = СокрЛП(Строка);
	ЧастиСтроки = СтрРазделить(Строка, ".", Истина);
	
	Если Строка = "" Или ЧастиСтроки.Количество() > 2 Тогда
		ВызватьИсключение НСтр("ru = 'Преобразование значения к типу Число не может быть выполнено.'");
	КонецЕсли;
	
	ДлинаДробнойЧасти = 0;
	Если ЧастиСтроки.Количество() > 1 Тогда
		ДлинаДробнойЧасти = СтрДлина(ЧастиСтроки[1]);
	КонецЕсли;
	
	Строка = СтрСоединить(ЧастиСтроки, "");
	Результат = 0;
	Если Строка <> "" Тогда
		Результат = Число(Строка) / Pow(10, ДлинаДробнойЧасти);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СформироватьСуммуПрописью(СуммаЧислом, Валюта, ВыводитьСуммуБезКопеек = Ложь, Знач КодЯзыка = Неопределено) Экспорт
	
	ПараметрыПрописи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Валюта, "ПараметрыПрописи", , КодЯзыка);
	Возврат СуммаПрописью(СуммаЧислом, ПараметрыПрописи, ВыводитьСуммуБезКопеек, КодЯзыка);
	
КонецФункции

Функция СуммаПрописью(СуммаЧислом, ПараметрыПрописи, ВыводитьСуммуБезДробнойЧасти = Ложь, Знач КодЯзыка = Неопределено)
	
	Если Не ЗначениеЗаполнено(КодЯзыка) Тогда
		КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	КонецЕсли;
	
	Сумма = ?(СуммаЧислом < 0, -СуммаЧислом, СуммаЧислом);
	Результат = ЧислоПрописью(Сумма, "L=" + КодЯзыка + ";ДП=Ложь", ПараметрыПрописи); // АПК:1297 АПК:1357
	Если ВыводитьСуммуБезДробнойЧасти И Цел(Сумма) = Сумма Тогда
		Результат = Лев(Результат, СтрНайти(Результат, "0") - 1);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

// Отключает у валюты 643 загрузку из интернета.
Процедура ОтключитьЗагрузкуКурсаВалюты643ИзИнтернета(Параметры) Экспорт
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.Валюты");
	Пока Выборка.Следующий() Цикл
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.Валюты");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
		
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			
			Валюта = Выборка.Ссылка.ПолучитьОбъект();
			Валюта.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Валюта);
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.Валюты");
КонецПроцедуры

Процедура УстановитьРасписаниеРегламентногоЗадания() Экспорт
	
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
	Задержка = ГенераторСлучайныхЧисел.СлучайноеЧисло(0, 21600); // С 0 до 6 часов утра.
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 1;
	Расписание.ПериодНедель = 1;
	Расписание.ВремяНачала = '00010101000000' + Задержка;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", Расписание);
	ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 600);
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 10);
	
	УстановитьПараметрыРегламентногоЗадания(ПараметрыЗадания);
	
КонецПроцедуры

Процедура УстановитьПараметрыРегламентногоЗадания(ИзменяемыеПараметры)
	РегламентныеЗаданияСервер.УстановитьПараметрыРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют, ИзменяемыеПараметры);
КонецПроцедуры

Функция ПараметрыАутентификацииНаСайте()
	Результат = Новый Структура;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		ДанныеАутентификации = МодульИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Если ДанныеАутентификации <> Неопределено Тогда
			Результат.Вставить("Пользователь", ДанныеАутентификации.Логин);
			Результат.Вставить("Пароль", ДанныеАутентификации.Пароль);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ВалютыЗагружаемыеИзИнтернета() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	НЕ Валюты.ПометкаУдаления
	|	И Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
	|	И Валюты.Код В(&ЗагружаемыеПоКлассификатору)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ЗагружаемыеПоКлассификатору", КодыВалютЗагружаемыхИзИнтернета());
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;
	
КонецФункции

Функция КодыВалютЗагружаемыхИзИнтернета() Экспорт
	
	КлассификаторТаблица = КлассификаторВалют();
	
	НайденныеСтроки = КлассификаторТаблица.НайтиСтроки(Новый Структура("RBCLoading", "истина"));
	ЗагружаемыеПоКлассификатору = КлассификаторТаблица.Скопировать(НайденныеСтроки, "Code").ВыгрузитьКолонку("Code");
	
	Возврат ЗагружаемыеПоКлассификатору;
	
КонецФункции

Функция ИмяСобытияЖурналаРегистрации()
	Возврат НСтр("ru = 'Валюты.Загрузка курсов валют'; en = 'Currency.Exchange rates import'", ОбщегоНазначения.КодОсновногоЯзыка());
КонецФункции

// См. ИнтеграцияПодсистемБСП.ПриИзмененииДанныхАутентификацииИнтернетПоддержки.
Процедура ПриИзмененииДанныхАутентификацииИнтернетПоддержки(ДанныеПользователя) Экспорт
	УстановитьПараметрыРегламентногоЗадания(Новый Структура("Использование", ДанныеПользователя <> Неопределено));
КонецПроцедуры

Функция ИдентификаторКлассификатора()
	
	Возврат "Currencies";
	
КонецФункции

Функция КлассификаторВалют() Экспорт
	
	КлассификаторXML = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКлассификаторами") Тогда
		ИдентификаторКлассификатора = ИдентификаторКлассификатора();
		
		МодульРаботаСКлассификаторами = ОбщегоНазначения.ОбщийМодуль("РаботаСКлассификаторами");
		Идентификаторы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторКлассификатора);
		Результат = МодульРаботаСКлассификаторами.ПолучитьФайлыКлассификаторов(Идентификаторы);
		
		Если ПустаяСтрока(Результат.КодОшибки) И Результат.ДанныеКлассификаторов <> Неопределено Тогда
			ОписаниеКлассификатора = Результат.ДанныеКлассификаторов.Найти(ИдентификаторКлассификатора, "Идентификатор");
			Если ОписаниеКлассификатора <> Неопределено Тогда
				ДвоичныеДанные = ПолучитьИзВременногоХранилища(ОписаниеКлассификатора.АдресФайла);
				
				ПотокВПамяти = Новый ПотокВПамяти;
				ЗаписьДанных = Новый ЗаписьДанных(ПотокВПамяти);
				ЗаписьДанных.Записать(ДвоичныеДанные);
				ЗаписьДанных.Закрыть();
				ПотокВПамяти.Перейти(0, ПозицияВПотоке.Начало);
				
				ЧтениеТекста = Новый ЧтениеТекста(ПотокВПамяти);
				КлассификаторXML = ЧтениеТекста.Прочитать();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если КлассификаторXML = Неопределено Тогда
		УстановитьПривилегированныйРежим(Истина);
		// {УАТ}
		Если уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП() 
			ИЛИ уатОбщегоНазначенияПовтИсп.ВариантПоставкиПРОФ() Тогда
			МодульУатЛокализация = ОбщегоНазначения.ОбщийМодуль("уатЛокализация");
			КлассификаторXML = МодульУатЛокализация.ПолучитьМакет_ОбщероссийскийКлассификаторВалют().ПолучитьТекст();
		Иначе
			КлассификаторXML = ПолучитьМакет("ОбщероссийскийКлассификаторВалют").ПолучитьТекст();
		КонецЕсли;
		// {/УАТ}
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Результат = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	Результат.Индексы.Добавить("Code");
	Результат.Индексы.Добавить("RBCLoading");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли