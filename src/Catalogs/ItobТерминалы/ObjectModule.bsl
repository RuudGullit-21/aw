#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	ПроверитьКорректностьЗаполненияДатчиков(Отказ);
	
	Если НЕ ДополнительныеСвойства.Свойство("ПропуститьПроверкиКодаТерминала") Тогда
		ПроверитьКорректностьКодаТерминала(Отказ);	
	КонецЕсли; 
	
	Если Модель = Справочники.ItobМоделиТерминалов.МобильныйКлиент Тогда
		ПроверитьКорректностьIMEIМобильногоКлиента(Отказ);	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Код = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ЗначениеЗаполнено(Модель)
			 И НЕ ЗначениеЗаполнено(СерверСбораДанных) Тогда
			 
			СерверСбораДанных = ?(Модель = Справочники.ItobМоделиТерминалов.МобильныйКлиент,
								  Справочники.ItobСерверыСбораДанных.СВМУ,
								  Справочники.ItobСерверыСбораДанных.Основной);
		КонецЕсли; 
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьКорректностьЗаполненияДатчиков(Отказ)
	
	Для каждого СтрокаДатчики Из Датчики Цикл
		Если СтрокаДатчики.Датчик.Пустая() Тогда
			ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'Таблица датчиков, строка №'") + СтрокаДатчики.НомерСтроки
															  + НСтр("ru = ', не указан датчик!'"),,,, Отказ);		
		КонецЕсли;
		
		Если СтрокаДатчики.Назначение.Пустая() Тогда
			ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'Таблица датчиков, строка №'") + СтрокаДатчики.НомерСтроки
															  + НСтр("ru = ', не указано назначение датчика!'"),,,, Отказ);		
		КонецЕсли;														  
	КонецЦикла;

КонецПроцедуры
 
Процедура ПроверитьКорректностьКодаТерминала(Отказ)
	
	Если ЗначениеЗаполнено(Код) Тогда
		КонтрольУникальностиКодаТерминала(Отказ);
	Иначе
		// Не заполнять код разрешено только для мобильных клиентов.
		Если НЕ Модель = Справочники.ItobМоделиТерминалов.МобильныйКлиент Тогда
			ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен код IMCS'"),,,, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Контроль уникальности кода в рамках сервера сбора данных.
//
Процедура КонтрольУникальностиКодаТерминала(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Код", Код);
	Запрос.УстановитьПараметр("СерверСбораДанных", СерверСбораДанных);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Флаг
	|ИЗ
	|	Справочник.ItobТерминалы КАК ItobТерминалы
	|ГДЕ
	|	ItobТерминалы.Код = &Код
	|	И ItobТерминалы.СерверСбораДанных = &СерверСбораДанных
	|	И НЕ ItobТерминалы.Ссылка = &Ссылка";
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		ТекстСообщения = СтрШаблон("Код терминала не уникален для указанного сервера сбора данных (%1)", СерверСбораДанных);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);	
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПроверитьКорректностьIMEIМобильногоКлиента(Отказ)
	
	Если ЗначениеЗаполнено(СокрЛП(НомерSimКарты)) Тогда
		КонтрольУникальностиIMEIМобильногоКлиента(Отказ);	
	Иначе			
		ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'Для мобильного клиента не заполнен номер SIM-карты'"),,,, Отказ);		
	КонецЕсли;
		
КонецПроцедуры

// Контроль уникальности IMEI мобильного клиента в рамках сервера сбора данных.
//
Процедура КонтрольУникальностиIMEIМобильногоКлиента(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("IMEI", IMEI);
	Запрос.УстановитьПараметр("СерверСбораДанных", СерверСбораДанных);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Флаг
	|ИЗ
	|	Справочник.ItobТерминалы КАК ItobТерминалы
	|ГДЕ
	|	ItobТерминалы.IMEI = &IMEI
	|	И ItobТерминалы.СерверСбораДанных = &СерверСбораДанных
	|	И НЕ ItobТерминалы.Ссылка = &Ссылка";
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		ТекстСообщения = СтрШаблон("IMEI мобильного устройства не уникален для указанного сервера сбора данных (%1)", СерверСбораДанных);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры
 
#КонецОбласти 

#КонецЕсли
