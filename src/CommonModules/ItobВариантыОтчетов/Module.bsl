////////////////////////////////////////////////////////////////////////////////
// Подсистема "Варианты отчетов" (сервер, переопределяемый).
// 
// Выполняется на сервере, изменяется под специфику прикладной конфигурации,
// но предназначен для использования только данной подсистемой.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Настройки подсистемы

// См. процедуру ВариантыОтчетовПереопределяемый.ОпределитьРазделыСВариантамиОтчетов.
//
// Параметры:
//   Разделы - СписокЗначений - Разделы в которые выведена команды открытия панели отчетов:
//       * Значение - ОбъектМетаданных: Подсистема - Метаданные подсистемы.
//           - Строка - Используется для панели отчетов начальной страницы.
//               В качестве раздела можно указать ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы().
//       * Представление - Строка - Заголовок панели отчетов этого раздела.
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
		
	Разделы.Добавить(Метаданные.Подсистемы.ItobСпутниковыйМониторинг, НСтр("ru = 'Отчеты'"));
	
	// ItobПланФакт
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.ПланФакт") Тогда
		ОбщийМодуль = ОбщегоНазначения.ОбщийМодуль("ItobПланФактВариантыОтчетов");
		ОбщийМодуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	// Конец ItobПланФакт
	
	// ItobУчетГСМ
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.УчетГСМ") Тогда
		ОбщийМодуль = ОбщегоНазначения.ОбщийМодуль("ItobУчетГСМНастройка");
		ОбщийМодуль.ВариантыОтчетовОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	// Конец ItobУчетГСМ
	
	// ItobОрганайзер
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.Органайзер") Тогда
		ОбщийМодуль = ОбщегоНазначения.ОбщийМодуль("ItobОрганайзерНастройка");
		ОбщийМодуль.ВариантыОтчетовОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	// Конец ItobОрганайзер
	
	// МобильныйКлиент.
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.МобильныйКлиент") Тогда
		Разделы.Добавить(Метаданные.Подсистемы["мкМобильныйКлиент"], НСтр("ru = 'Отчеты по разделу ""Мобильный клиент""'"));
	КонецЕсли;
	// Конец МобильныйКлиент.
	
КонецПроцедуры

// См. процедуру ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
// Параметры:
//  Настройки	 - Коллекция - Используется для описания настроек отчетов и вариантов
//  см. описание к ВариантыОтчетов.ДеревоПредопределенных().
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobАнализПосещенияГеографическихЗон);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobАнализРасходаТоплива);	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobВизуализацияКалибровочногоГрафика);	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobВыдачиТоплива);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobДвиженияИСтоянки);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobМестоположениеОбъектовСКД);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobОтчетПоАналоговымДатчикам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobОтчетПоДискретнымДатчикам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobОтчетПоПараметрамВыработки);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobОтчетПоПростоямПриЗаведенномДвигателе);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobОтчетПоТопливу);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobОтчетПоТопливуИнтерактивныйВыборИнтервала);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobПосещениеГеографическихЗон);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobМаршрутПоГеозонамДиаграммаГанта);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobМаршрутПоГеозонам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobОтчетПоИмпульснымДатчикам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ItobСообщенияТерминала);
		
	// ItobПланФакт
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.ПланФакт") Тогда
		ОбщийМодуль = ОбщегоНазначения.ОбщийМодуль("ItobПланФактВариантыОтчетов");
		ОбщийМодуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	// Конец ItobПланФакт
	
	// ItobУчетГСМ
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.УчетГСМ") Тогда
		ОбщийМодуль = ОбщегоНазначения.ОбщийМодуль("ItobУчетГСМНастройка");
		ОбщийМодуль.ВариантыОтчетовНастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	// Конец ItobУчетГСМ
	
	// МобильныйКлиент.
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.МобильныйКлиент") Тогда
		ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты["мкИзмененияСтатусовМобильныхУстройств"]);
		ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты["мкРеестрСообщений"]);
		ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты["мкСтатусыВыполненияЗаданий"]);
	КонецЕсли;
	// Конец МобильныйКлиент.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.БезопасностьВождения") Тогда
		ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты["ItobАнализКачестваВождения"]);
		ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты["ItobЖурналНарушенийВождения"]);
		ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты["ItobРейтингОбъектовПоКачествуВождения"]);
	КонецЕсли;
	
КонецПроцедуры

// См. процедуру ВариантыОтчетовПереопределяемый.ЗарегистрироватьИзмененияКлючейВариантовОтчетов.
//
// Параметры:
//  Изменения	 - ТаблицаЗначений	 - Таблица изменений имен вариантов. Колонки:
//  	* Отчет - ОбъектМетаданных - Метаданные отчета, в схеме которого изменилось имя варианта.
//  	* СтароеИмяВарианта - Строка - Старое имя варианта, до изменения.
//  	* АктуальноеИмяВарианта - Строка - Текущее (последнее актуальное) имя варианта.
//
Процедура ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения) Экспорт
	
КонецПроцедуры

#КонецОбласти
