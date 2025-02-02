////////////////////////////////////////////////////////////////////////////////
// Географические зоны (вызов сервера)
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает текст скрипта отображения географической зоны.
//
// Параметры:
//  ГеографическаяЗонаСсылка - СправочникСсылка.упГеографическиеЗоны - Ссылка на географическую зону.
//  Автомасштаб				 - Булево								 - Автомасштаб.
//  ТаблицаВершинПолигона	 - ТаблицаЗначений						 - Вершины полигона.
// 
// Возвращаемое значение:
//  Строка - Скрипт отображения географической зоны.
//
Функция ПолучитьСкриптОтображенияГеографическойЗоныСервер(ГеографическаяЗонаСсылка, Автомасштаб, Знач ТаблицаВершинПолигона = Неопределено) Экспорт
	
	Если ТаблицаВершинПолигона = Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", ГеографическаяЗонаСсылка);
		Запрос.Текст = "ВЫБРАТЬ
		               |	ItobТочкиГеографическихЗон.Широта,
		               |	ItobТочкиГеографическихЗон.Долгота
		               |ИЗ
		               |	РегистрСведений.ItobТочкиГеографическихЗон КАК ItobТочкиГеографическихЗон
		               |ГДЕ
		               |	ItobТочкиГеографическихЗон.ГеографическаяЗона = &Ссылка
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	ItobТочкиГеографическихЗон.НомерТочки";
		
		ТаблицаВершинПолигона = Запрос.Выполнить().Выгрузить();
	КонецЕсли;

	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(
		"var pointList = [];
		|var pt = null;
		|destroy_geozones_control();
		|create_geozones_control();");

	Для Счетчик = 0 По ТаблицаВершинПолигона.Количество()-1 Цикл		
		МассивСтрок.Добавить("
			|pt = new OpenLayers.LonLat("+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(ТаблицаВершинПолигона[Счетчик].Долгота)
				+", "+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(ТаблицаВершинПолигона[Счетчик].Широта)+");
			|pt.transform(m_map.displayProjection, m_map.getProjectionObject());
			|pointList.push(new OpenLayers.Geometry.Point(pt.lon, pt.lat));");
	
	КонецЦикла;
	
	МассивСтрок.Добавить("geozones_control.handler.setPoints(pointList);");
	
	// Автомасштаб
	Если Автомасштаб И (ТаблицаВершинПолигона.Количество() > 0) Тогда
		МассивСтрок.Добавить("m_map.zoomToExtent(geozones_control.handler.polygon.geometry.getBounds());");	
	КонецЕсли;
		
	Возврат СтрСоединить(МассивСтрок, Символы.ПС);

КонецФункции // ПолучитьСкриптОтображенияГеографическойЗоныСервер()

// Процедура заполняет точками географическую зону.
//
// Параметры:
//  ГеографическаяЗонаСсылка			 - СправочникСсылка.упГеографическиеЗоны - Ссылка на географическую зону.
//  СтрНовыеКоординатыГеографическойЗоны - Строка								 - Многострочная строка с координатами.
//
Процедура ЗаполнитьТочкиГеографическойЗоны(ГеографическаяЗонаСсылка, СтрНовыеКоординатыГеографическойЗоны) Экспорт
	
	НаборЗаписей = РегистрыСведений.ItobТочкиГеографическихЗон.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ГеографическаяЗона.Значение = ГеографическаяЗонаСсылка;
	НаборЗаписей.Отбор.ГеографическаяЗона.Использование = Истина;
	
	Если НЕ ПустаяСтрока(СтрНовыеКоординатыГеографическойЗоны) Тогда
		Для Счетчик = 1 По СтрЧислоСтрок(СтрНовыеКоординатыГеографическойЗоны) Цикл
			СтрокаКоординат = СтрПолучитьСтроку(СтрНовыеКоординатыГеографическойЗоны,Счетчик);
			СтрокаКоординат = СтрЗаменить(СтрокаКоординат,",",Символы.ПС);
			НовСтрокаТочки = НаборЗаписей.Добавить();
			НовСтрокаТочки.ГеографическаяЗона = ГеографическаяЗонаСсылка;
			НовСтрокаТочки.НомерТочки = Счетчик;
			НовСтрокаТочки.Долгота = Число(СокрЛП(СтрПолучитьСтроку(СтрокаКоординат,1)));
			НовСтрокаТочки.Широта = Число(СокрЛП(СтрПолучитьСтроку(СтрокаКоординат,2)));
		КонецЦикла;	
	КонецЕсли; 
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Функция возвращает текст скрипта, для получения всех географических зон.
//
// Параметры:
//  ТекстИПараметрыЗапросаУсловия	 - Строка	 - Текст и параметры запроса условия.
// 
// Возвращаемое значение:
//  Строка - Скрипт географических зон.
//
Функция ПолучитьТекстСкриптаГеографическиеЗоны(ТекстИПараметрыЗапросаУсловия = Неопределено) Экспорт

	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(
		"var find_lays = m_map.getLayersByName(""AllGeozonLayer"");
		|var vectorLayer = null;
		|if (find_lays.length == 0) {
		|	vectorLayer = new OpenLayers.Layer.Vector(""AllGeozonLayer"", {displayInLayerSwitcher: false});
		|	m_map.addLayer(vectorLayer);
		|}
		|else {
		|	vectorLayer = find_lays[0];
		|	vectorLayer.destroyFeatures();
		|}
		|var Features = [];");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ItobГеографическиеЗоны.Ссылка
	|ПОМЕСТИТЬ ItobГеографическиеЗоны
	|ИЗ
	|	Справочник.ItobГеографическиеЗоны КАК ItobГеографическиеЗоны
	|ГДЕ
	|	НЕ ItobГеографическиеЗоны.ПометкаУдаления
	|	И &ДопУсловие
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ItobТочкиГеографическихЗон.ГеографическаяЗона КАК Ссылка,
	|	ItobТочкиГеографическихЗон.ГеографическаяЗона.Наименование КАК Наименование,
	|	ItobТочкиГеографическихЗон.НомерТочки КАК НомерСтроки,
	|	ItobТочкиГеографическихЗон.Широта,
	|	ItobТочкиГеографическихЗон.Долгота
	|ИЗ
	|	РегистрСведений.ItobТочкиГеографическихЗон КАК ItobТочкиГеографическихЗон
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ItobГеографическиеЗоны КАК ItobГеографическиеЗоны
	|		ПО ItobТочкиГеографическихЗон.ГеографическаяЗона = ItobГеографическиеЗоны.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.ItobГеографическиеЗоны", "Справочник."+ItobВызовСервераПовтИсп.ПолучитьИмяОбъекта("ГеографическиеЗоны")); 			   
	
	Если ТекстИПараметрыЗапросаУсловия = Неопределено ИЛИ ПустаяСтрока(ТекстИПараметрыЗапросаУсловия.Текст) Тогда 
		Запрос.УстановитьПараметр("ДопУсловие", Истина);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ДопУсловие", ТекстИПараметрыЗапросаУсловия.Текст);
		Счетчик = 0;
		Для Каждого Параметр Из ТекстИПараметрыЗапросаУсловия.Параметры Цикл
			Запрос.УстановитьПараметр("Параметр" + Строка(Счетчик), Параметр);
			Счетчик = Счетчик + 1;
		КонецЦикла;
	КонецЕсли;
	
	ВыборкаГеографическойЗоны = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаГеографическойЗоны.Следующий() Цикл
		
		ВыборкаТочки = ВыборкаГеографическойЗоны.Выбрать();
				
		ЦветВеб = "fbcf7c";
			
		МассивСтрок.Добавить(
			"	var pointList = [];
			|	var pt = null;");
		
		Пока ВыборкаТочки.Следующий() Цикл
							
			МассивСтрок.Добавить(
				"pt = new OpenLayers.LonLat("+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(ВыборкаТочки.Долгота)
					+", "+ItobОбщегоНазначенияКлиентСервер.ФорматироватьКоординаты(ВыборкаТочки.Широта)+");
				|pt.transform(m_map.displayProjection, m_map.getProjectionObject());
				|pointList.push(new OpenLayers.Geometry.Point(pt.lon, pt.lat));");
				
		КонецЦикла;
		
		МассивСтрок.Добавить(
			"var Geozon_style = {
			|					fillColor: ""#"+ЦветВеб+""",
			|					fillOpacity: 0.4,
			|					label: '"+СтрЗаменить(ВыборкаГеографическойЗоны.Наименование,"'","""")+"',
			|					hoverFillColor: ""white"",
			|					hoverFillOpacity: 0.8,
			|					strokeColor: ""#004A80"",
			|					strokeOpacity: 0.8,
			|					strokeWidth: 1,
			|					strokeLinecap: ""round"",
			|					hoverStrokeColor: ""#FDC689"",
			|					hoverStrokeOpacity: 0.5,
			|					hoverStrokeWidth: 0.2,
			|					pointRadius: 4,
			|					hoverPointRadius: 1,
			|					hoverPointUnit: ""%"",
			|					pointerEvents: ""visiblePainted""}
			|   var linearRing = new OpenLayers.Geometry.LinearRing(pointList);
			|   var polygonFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Polygon([linearRing]),null,Geozon_style);
			|Features.push(polygonFeature);");
			
	КонецЦикла;
	
	МассивСтрок.Добавить("
						 |	vectorLayer.addFeatures(Features);
						 |	set_behind_marker_layer(vectorLayer)");
	
	
	Возврат СтрСоединить(МассивСтрок, Символы.ПС);	

КонецФункции

// Функция ограниченная и используется в двух местах, перенесена, что бы избавиться от дублей в коде.
//  Изменения не рекомендуются.
//  Переадресация на общий модуль ItobГеографическиеЗоны.
//
// Параметры:
//  Запрос	 - Запрос	 - Запрос, для получения географических зон.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Географические зоны.
//
Функция ПолучитьГеографическиеЗоныОбработкаЗапроса(Запрос) Экспорт
	Возврат ItobГеографическиеЗоны.ПолучитьГеографическиеЗоныОбработкаЗапроса(Запрос);
КонецФункции // ПолучитьГеографическиеЗоныОбработкаЗапроса()

// Функция возвращает таблицу географических зон.
//
// Параметры:
//  ГруппаГеографическихЗон	- СправочникСсылка.ItobГеографическаяЗона - Если установлено значение Неопределено,
//							   то выбираются все географические зоны за исключением помеченных на удаление.
//
// Возвращаемое значение:
//   ТаблицаЗначений   		- Таблица географических зон.
//
Функция ПолучитьГеографическиеЗоныПоГруппе(ГруппаГеографическихЗон) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГеографическиеЗоныПустаяСсылка", ItobОбщегоНазначения.ПустаяСсылкаОбъекта("ГеографическиеЗоны"));
	Запрос.УстановитьПараметр("ГруппаГеографическихЗон", ГруппаГеографическихЗон);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ItobТочкиГеографическихЗон.ГеографическаяЗона КАК Ссылка,
	               |	ItobТочкиГеографическихЗон.НомерТочки КАК НомерСтроки,
	               |	ItobТочкиГеографическихЗон.Широта КАК Широта,
	               |	ItobТочкиГеографическихЗон.Долгота КАК Долгота,
	               |	ItobТочкиГеографическихЗон.Широта КАК Широта1,
	               |	ItobТочкиГеографическихЗон.Долгота КАК Долгота1,
	               |	ItobТочкиГеографическихЗон.ГеографическаяЗона.Код КАК Код
	               |ИЗ
	               |	РегистрСведений.ItobТочкиГеографическихЗон КАК ItobТочкиГеографическихЗон
	               |ГДЕ
	               |	НЕ ItobТочкиГеографическихЗон.ГеографическаяЗона.ПометкаУдаления
	               |	И ВЫБОР
	               |			КОГДА &ГруппаГеографическихЗон = &ГеографическиеЗоныПустаяСсылка
	               |					ИЛИ &ГруппаГеографическихЗон = НЕОПРЕДЕЛЕНО
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ItobТочкиГеографическихЗон.ГеографическаяЗона В ИЕРАРХИИ (&ГруппаГеографическихЗон)
	               |		КОНЕЦ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка,
	               |	НомерСтроки
	               |ИТОГИ
	               |	МИНИМУМ(Широта),
	               |	МИНИМУМ(Долгота),
	               |	МАКСИМУМ(Широта) КАК Широта1,
	               |	МАКСИМУМ(Долгота) КАК Долгота1
	               |ПО
	               |	Ссылка";	
				   
	Возврат ПолучитьГеографическиеЗоныОбработкаЗапроса(Запрос);

КонецФункции // ПолучитьГеографическиеЗоны()

// Функция - Обработать команду географические зоны.
//
// Параметры:
//  Форма		 - 	УправляемаяФорма - форма.
//  ИмяКоманда	 - 	Строка - имя команды, которую нужно обработать.
// 
// Возвращаемое значение:
//  Строка - текст скрипта.
//
Функция ОбработатьКомандуГеографическиеЗоны(Форма, ИмяКоманда) Экспорт 
	
	ТекстИПараметрыЗапросаУсловия = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.ФильтрыНаКартах") Тогда
		МодульФильтрыНаКартах = ОбщегоНазначения.ОбщийМодуль("ItobФильтрыНаКартах");
		ТекстИПараметрыЗапросаУсловия =  МодульФильтрыНаКартах.ОбработатьКоманду(Форма, 
																				 ИмяКоманда, 
																				 Форма.ГеографическиеЗоныФильтры, 
																				 "ГеографическиеЗоныГруппаВсе", 
																				 "ГеографическиеЗоныГруппаПользовательские");
	КонецЕсли;
	ТекстСкрипта = ПолучитьТекстСкриптаГеографическиеЗоны(ТекстИПараметрыЗапросаУсловия);
	
	
	Возврат ТекстСкрипта;
	
КонецФункции

#КонецОбласти



 
