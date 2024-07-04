
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает адрес страницы по заданным географическим координатам, для обратного геокодирования.
//
// Параметры:
//  Широта	 - Число - географические координаты.
//  Долгота	 - Число - географические координаты.
// 
// Возвращаемое значение:
//  Строка - Адрес http страницы.
//
Функция ОбратноеГеокодированиеПолучитьАдресСтраницы(Широта, Долгота) Экспорт
	
	Если ПустаяСтрока(АдресСервера) Тогда
		АдресСервера = "http://open.mapquestapi.com/nominatim/v1/";	
	
	КонецЕсли;
	
	АдресСтраницы = АдресСервера + "reverse?format=xml&lat="
	  +ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(Широта)
		+"&lon="+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(Долгота)
		+"&zoom=18&addressdetails=1&accept-language=ru&email=support@itob.ru";
		
	Если Не ПустаяСтрока(Ключ) Тогда
		АдресСтраницы = АдресСтраницы+"&key="+СокрЛП(Ключ);			
	КонецЕсли;	
	
	Возврат АдресСтраницы; 

КонецФункции // ПолучитьАдресСтраницыОбратноеГеокодирование()

// Функция разбирает файл ответа web-сервиса геокодирования.
//
// Параметры:
//  ИмяФайла - Строка- Имя XML файла, который требуется разобрать.
//
// Возвращаемое значение:
//	ТаблицаЗначений   - Разобранные адреса:
// 	* Страна - Строка - Страна.
// 	* Индекс - Строка - Индекс.
// 	* Регион - Строка - Регион.
// 	* Район - Строка - Район.
// 	* Город - Строка - Город.
// 	* НаселенныйПункт - Строка - НаселенныйПункт.
// 	* Улица - Строка - Улица.
// 	* Дом - Строка - Дом.
// 	* Корпус - Строка - Корпус.
// 	* Представление - Строка - Представление.
// 	* Широта - Строка - Широта.
// 	* Долгота - Строка - Долгота.
// 	* Точность - Строка - Точность.
// 	* ГеоРамкаСевер - Строка - Географическая рамка север.
// 	* ГеоРамкаЮг - Строка - Географическая рамка юг.
// 	* ГеоРамкаЗапад - Строка - Географическая рамка запад.
// 	* ГеоРамкаВосток - Строка - Географическая рамка восток. 
//
Функция ОбратноеГеокодированиеРазобратьФайлОтвета(ИмяФайла) Экспорт
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	ТаблицаРезультат.Колонки.Добавить("Страна");		
	ТаблицаРезультат.Колонки.Добавить("Индекс");		
	ТаблицаРезультат.Колонки.Добавить("Регион");
	ТаблицаРезультат.Колонки.Добавить("Район");
	ТаблицаРезультат.Колонки.Добавить("Город");
	ТаблицаРезультат.Колонки.Добавить("НаселенныйПункт");
	ТаблицаРезультат.Колонки.Добавить("Улица");
	ТаблицаРезультат.Колонки.Добавить("Дом");
	ТаблицаРезультат.Колонки.Добавить("Корпус");
	ТаблицаРезультат.Колонки.Добавить("Представление");
	ТаблицаРезультат.Колонки.Добавить("Широта");
	ТаблицаРезультат.Колонки.Добавить("Долгота");
	ТаблицаРезультат.Колонки.Добавить("Точность");
	ТаблицаРезультат.Колонки.Добавить("ГеоРамкаСевер");
	ТаблицаРезультат.Колонки.Добавить("ГеоРамкаЮг");	
	ТаблицаРезультат.Колонки.Добавить("ГеоРамкаЗапад");
	ТаблицаРезультат.Колонки.Добавить("ГеоРамкаВосток");
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяФайла);
			
	СтруктураОтвета = Новый Структура("place_id,osm_type,osm_id,lat,lon,address,
		|house_number,road,city,hamlet,county,state_district,state,
		|administrative,postcode,country,country_code");
	СтруктураОтвета.address = Неопределено;
	СтруктураОтвета.house_number = "";
	СтруктураОтвета.road = "";
	
	Пока ЧтениеXML.Прочитать() Цикл
				
		Если ЧтениеXML.Имя = "result" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			СтруктураОтвета.place_id = СокрЛП(ЧтениеXML.ПолучитьАтрибут("place_id"));
			СтруктураОтвета.osm_type = СокрЛП(ЧтениеXML.ПолучитьАтрибут("osm_type"));
			СтруктураОтвета.osm_id   = СокрЛП(ЧтениеXML.ПолучитьАтрибут("osm_id"));
			СтруктураОтвета.lat      = Число(ЧтениеXML.ПолучитьАтрибут("lat"));
			СтруктураОтвета.lon      = Число(ЧтениеXML.ПолучитьАтрибут("lon"));
						
			РезультатЧтения = ЧтениеXML.Прочитать();
			СтруктураОтвета.address  = СокрЛП(ЧтениеXML.Значение);
			
		КонецЕсли;
		
		Если ЧтениеXML.Имя = "addressparts" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			РезультатЧтения = Истина;
			Пока РезультатЧтения И НЕ (ЧтениеXML.Имя = "addressparts" И ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента) Цикл
				
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
					ИмяКлюча = ЧтениеXML.Имя;
					
					Если СтруктураОтвета.Свойство(ИмяКлюча) Тогда
						ЧтениеXML.Прочитать();
						СтруктураОтвета[ИмяКлюча] = ЧтениеXML.Значение;
						
					КонецЕсли;					
					
				КонецЕсли;
				
				РезультатЧтения = ЧтениеXML.Прочитать();	
			КонецЦикла;	
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
			
	Если СтруктураОтвета.address <> Неопределено Тогда
		СтрокаРезультат = ТаблицаРезультат.Добавить();
		СтрокаРезультат.Страна          = СтруктураОтвета.country;
		СтрокаРезультат.Индекс          = СтруктураОтвета.postcode;
		СтрокаРезультат.Регион          = СтруктураОтвета.state;
		СтрокаРезультат.Район           = СтруктураОтвета.county;
		СтрокаРезультат.Город           = СтруктураОтвета.city;
		СтрокаРезультат.НаселенныйПункт = СтруктураОтвета.hamlet;
		СтрокаРезультат.Улица           = СтруктураОтвета.road;
		СтрокаРезультат.Дом             = СтруктураОтвета.house_number;
		СтрокаРезультат.Корпус          = "";
		СтрокаРезультат.Представление   = СтруктураОтвета.address;
		СтрокаРезультат.Широта          = СтруктураОтвета.lat;
		СтрокаРезультат.Долгота         = СтруктураОтвета.lon;
		
		Если Не ПустаяСтрока(СтруктураОтвета.house_number) Тогда
			СтрокаРезультат.Точность = 6;			
		ИначеЕсли Не ПустаяСтрока(СтруктураОтвета.road) Тогда
			СтрокаРезультат.Точность = 3;			
		Иначе
			СтрокаРезультат.Точность = 1;		
		КонецЕсли;
				
		СтрокаРезультат.ГеоРамкаСевер   = СтруктураОтвета.lat;
		СтрокаРезультат.ГеоРамкаЮг      = СтруктураОтвета.lat;
		СтрокаРезультат.ГеоРамкаЗапад   = СтруктураОтвета.lon;
		СтрокаРезультат.ГеоРамкаВосток  = СтруктураОтвета.lon;		
	
	КонецЕсли;
	
	Возврат ТаблицаРезультат;	

КонецФункции // ПолучитьАдресСтраницыОбратноеГеокодирование()

#КонецОбласти

#КонецЕсли
