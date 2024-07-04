#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаПроверкиЗаполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НачПериода > КонПериода Тогда
		ТекстОшибки = НСтр("ru='Начало периода не может быть больше даты конца периода'");
		ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			Неопределено, // ОбъектИлиСсылка
			"ItobМаршрутПоГеозонамДиаграммаГанта",
			"Отчет", // ПутьКДанным
			Отказ);
	КонецЕсли;
		
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
	
// Функция выполняет формирование диаграммы ганта отчета по географическим зонам.
//
Процедура ВывестиДиаграммуГанта(ДиаграммаГанта, НачПериода, КонПериода, Объект) Экспорт
	
			
	// Формируем маршрут
	
	Маршрут = ItobОперативныйМониторинг.СформироватьМаршрутОбъектаМониторинга(Объект, НачПериода, КонПериода);
	Если (Маршрут.Количество() = 1) И (Маршрут[0].Состояние = Перечисления.ItobСостоянияТерминалов.НетДанных) Тогда  
		// Если по текущему объекту нет данных
		Возврат;
	КонецЕсли;	
		
	ТаблицаГеографическихЗон = ItobГеографическиеЗоныВызовСервера.ПолучитьГеографическиеЗоныПоГруппе(Неопределено);
	
	СоответствиеИдЗона = Новый Соответствие;
	Для Каждого СтрокаТаблицыГеографическихЗон Из ТаблицаГеографическихЗон Цикл
		СоответствиеИдЗона["GEOZONE" + СтрокаТаблицыГеографическихЗон.ГеографическаяЗона.Код] = СтрокаТаблицыГеографическихЗон.ГеографическаяЗона;
	КонецЦикла; 
	
	Для Каждого ТочкаМаршрута Из Маршрут Цикл
		
		ТекЗоны = Новый ТаблицаЗначений;
		ТекЗоны.Колонки.Добавить("ГеографическаяЗона");
		ТекЗоны.Колонки.Добавить("Уровень");
		
		Если (НЕ ЗначениеЗаполнено(ТочкаМаршрута.Широта)) ИЛИ (НЕ ЗначениеЗаполнено(ТочкаМаршрута.Долгота))  Тогда
			Продолжить;			
		
		КонецЕсли;
		
		Для Каждого СтрЗоны Из ТаблицаГеографическихЗон Цикл                                             
			ПараметрыЗоны = ItobГеографическиеЗоны.ПараметрыПроверяемойЗоны();
			ЗаполнитьЗначенияСвойств(ПараметрыЗоны, СтрЗоны);
			ПараметрыЗоны.ШиротыЗоны = СтрЗоны.МассивУ;
			ПараметрыЗоны.ДолготыЗоны = СтрЗоны.МассивХ;	 
			Если ItobГеографическиеЗоны.ТочкаВГеозоне(ТочкаМаршрута.Широта, ТочкаМаршрута.Долгота, ПараметрыЗоны) Тогда
				ЗаполнитьЗначенияСвойств(ТекЗоны.Добавить(), СтрЗоны);
				
				ИмяГеографическойЗоны = "GEOZONE" + СтрЗоны.ГеографическаяЗона.Код;
				Если Маршрут.Колонки.Найти(ИмяГеографическойЗоны) = Неопределено Тогда
					Маршрут.Колонки.Добавить(ИмяГеографическойЗоны);	
				КонецЕсли;
				
				ТочкаМаршрута[ИмяГеографическойЗоны] = 1;
			КонецЕсли;	
		КонецЦикла;					
	КонецЦикла;	
	
	ДиаграммаГанта.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.Минута;
	ДиаграммаГанта.АвтоОпределениеПолногоИнтервала = Ложь;
	ДиаграммаГанта.УстановитьПолныйИнтервал(Маршрут[0].Период, Маршрут[Маршрут.Количество()-1].Период);
	ДиаграммаГанта.АвтоУстановкаТекстаТочек = Истина;
	
	ДиаграммаГанта.Очистить();
	
	Для Каждого ЭлементСоответствия Из СоответствиеИдЗона Цикл
		ТекИдЗоны = ЭлементСоответствия.Ключ;
		
		Если Маршрут.Колонки.Найти(ТекИдЗоны) = Неопределено Тогда
			Продолжить;
		
		КонецЕсли;
		
		ЗонаСсылка = ЭлементСоответствия.Значение;
		
		Точка = ДиаграммаГанта.УстановитьТочку(ЗонаСсылка);
		Точка.Текст = Строка(ЗонаСсылка);
		Серия = ДиаграммаГанта.УстановитьСерию("Серия1");
		Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);
		
		КоличествоТочек = 0;
		НачНахожденияВЗоне = '00010101';
		Для Счетчик = 0 По Маршрут.Количество()-1 Цикл
			Если Маршрут[Счетчик][ТекИдЗоны] = 1 Тогда
				
				Если КоличествоТочек = 0 Тогда
					НачНахожденияВЗоне = Маршрут[Счетчик].Период;
				
				КонецЕсли;
				
				КоличествоТочек = КоличествоТочек + 1;
				
				Если Счетчик = Маршрут.Количество()-1 И КоличествоТочек > 2 Тогда
					// Уже край таблицы
					Интервал = Значение.Добавить();
					Интервал.Начало = НачНахожденияВЗоне;
					Интервал.Конец = Маршрут[Счетчик].Период;
					Интервал.Расшифровка = Новый Структура("НачПериода,КонПериода,Объект",НачНахожденияВЗоне,Маршрут[Счетчик].Период,Объект);
				
				КонецЕсли;
				
			ИначеЕсли Маршрут[Счетчик][ТекИдЗоны] <> 1 Тогда
				Если КоличествоТочек > 0 Тогда
					
					Если Счетчик < Маршрут.Количество()-1 Тогда
						Если Маршрут[Счетчик+1][ТекИдЗоны]=1 Тогда
							// Считаем это обычной флуктуацией
							КоличествоТочек = КоличествоТочек + 1;
							Продолжить;
						
						КонецЕсли;					
					КонецЕсли;
					
					Если КоличествоТочек <= 2 Тогда
						// Тоже склонны считать что это не стоит включать в отчет
						КоличествоТочек = 0;
						Продолжить;
					
					КонецЕсли;				
					
					// Покидание зоны
					Интервал = Значение.Добавить();
					Интервал.Начало = НачНахожденияВЗоне;
					Интервал.Конец = Маршрут[Счетчик].Период;
					Интервал.Расшифровка = Новый Структура("НачПериода,КонПериода,Объект",НачНахожденияВЗоне,Маршрут[Счетчик].Период,Объект);
										
				    КоличествоТочек = 0;		
				КонецЕсли;				
			КонецЕсли;					
		КонецЦикла;				
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
