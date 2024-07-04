////////////////////////////////////////////////////////////////////////////////
// Оперативный мониторинг (клиент)
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция - Проверить поле HTML
//
// Параметры:
//  ПолеHTML - ПолеФормы - Поле HTML.
// 
// Возвращаемое значение:
//  Булево 
//
Функция ПроверитьПолеHTML(ПолеHTML) Экспорт
	
	Возврат НЕ (ПолеHTML.Документ = Неопределено
				ИЛИ ПолеHTML.Документ.URL = "about:blank"
				ИЛИ НЕ ПолеHTML.Документ.readyState = "complete");
	
КонецФункции
 
// Выполняет скрипт на поле HTML, с учетом вида браузера.
//
// Параметры:
//  ПолеHTML	 - ПолеФормы - Поле HTML.
//  ТекстСкрипта - Строка	 - Текст скрипта.
// 
// Возвращаемое значение:
//  Неопределено - Неопределено.
//
Функция ВыполнитьСкриптНаПолеHTML(ПолеHTML, Знач ТекстСкрипта) Экспорт
	
	Если НЕ ПроверитьПолеHTML(ПолеHTML) Тогда
		Возврат Неопределено;	
	КонецЕсли; 
					
	Попытка
		Окно = ОкноДляВыполненияСкрипта(ПолеHTML.Документ);
		Если НЕ Окно = Неопределено Тогда
			Окно.makeInjection(ТекстСкрипта);	
		КонецЕсли;	
	Исключение
	    ItobОбщегоНазначенияВызовСервера.ЗаписьЖурналаРегистрацииОшибка(НСтр("ru = 'Ошибка при выполнении JS скрипта'", "ru"),
																	    ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки; 
	 
	
КонецФункции

// Проверяет доступность сервера CsmSvc.
//  При этом запрашивается тестовая страница по протоколу HTTP.
//
// Параметры:
//  ИмяСервера	 - Строка				 - Адрес сервера в формате <IP>:<Порт>, или <DNS имя>:<Порт>.
//  ПортСервера	 - Число, Неопределено	 - Порт сервера.
// 
// Возвращаемое значение:
//  Булево - Истина если доступен, Ложь если не доступен.
//
Функция ПроверитьДоступностьСервисаCsmSvc(ИмяСервера, ПортСервера) Экспорт
	
	#Если ВебКлиент Тогда
		
	// Запрашиваем данные на сервере	
	Возврат ItobОперативныйМониторингВызовСервера.ПроверитьДоступностьСервисаCsmSvc(ИмяСервера, ПортСервера);
		
	#Иначе	
	
	Соединение = Новый HTTPСоединение(ИмяСервера,ПортСервера,,,,10);
	Запрос = Новый HTTPЗапрос("/index.html");
	
	Попытка
		Ответ = Соединение.ВызватьHTTPМетод("GET", Запрос);
		Возврат Ответ.КодСостояния = 200;		
		
	Исключение
		Возврат Ложь;
	
	КонецПопытки;	
		
	#КонецЕсли	

КонецФункции // ПроверитьДоступностьСервисаCsmSvc()

// Определяет часовой пояс клиента.
//
Процедура ОпределениеЧасовогоПоясаСеанса() Экспорт
	
	МестноеВремяКлиента = МестноеВремя('20100101');
	РазницаВоВремени=Строка((МестноеВремяКлиента-'20100101')/(60*60));
	Знак = ?(Число(РазницаВоВремени)<0,"","+");
	МестныйЧасовойПояс="GMT"+Знак+РазницаВоВремени+":00";
	ItobОперативныйМониторингВызовСервера.УстановкаЧасовогоПоясаСеанса(МестныйЧасовойПояс);

КонецПроцедуры

// Обрабатывает нажатие на карту.
//
// Параметры:
//  Элемент				 - ПолеФормы - Не используется.
//  ДанныеСобытия		 - Произвольный	 - Данные события.
//  СтандартнаяОбработка - Булево		 - В данный параметр передается признак выполнения
//										стандартной (системной) обработки события.
//
//  		Если в теле процедуры-обработчика установить данному параметру значение Ложь,
//  		стандартная обработка события производиться не будет.
//
Процедура ОбработатьНажатиеНаПолеКарты(Элемент, ДанныеСобытия, СтандартнаяОбработка) Экспорт
	
	#Если НЕ ВебКлиент Тогда					
		
	Попытка
	
		ИмяСсылки = ДанныеСобытия.Href;
		Если Лев(ИмяСсылки, 11) <> "v8config://" Тогда
			Возврат;
		
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		СтрокаИмяФормы = СтрЗаменить(ИмяСсылки, "v8config://", "");
		СтрокаИмяФормы = СтрЗаменить(СтрокаИмяФормы, "/", "");
		
		ОткрытьФорму(СтрокаИмяФормы);
	
	Исключение
		ItobОбщегоНазначенияВызовСервера.ЗаписьЖурналаРегистрацииОшибка(НСтр("ru = 'Открытие формы'; en = 'Open a form'", "ru"),ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;	
		
	#КонецЕсли
	
КонецПроцедуры

// Проверяет вариант подключения.
// 
// Возвращаемое значение:
//  Булево - Истина;
//
Функция ПроверитьВариантПодключения() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Обработчик команды закрытия вариант подключения.
//
// Параметры:
//  Результат				 - КодВозвратаДиалога	 - Код возврата диалога вопроса.
//  ДополнительныеПараметры	 - Произвольный			 - Не используется.
//
Процедура ОбработкаКомандыЗакрытияВариантПодключения(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.OK Тогда
		ПрекратитьРаботуСистемы();		
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОкноДляВыполненияСкрипта(Документ)
	
	Окно = Документ.parentWindow;  // IE, тонкий клиент до 8.3.13 (включительно)
	Если Окно = Неопределено Тогда
		Окно = Документ.defaultView;	// Другие браузеры и тонкий клиент начиная с версии 8.3.14.
	КонецЕсли;
	
	
	Возврат Окно;
	
КонецФункции
 
#КонецОбласти 
