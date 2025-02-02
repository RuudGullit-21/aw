////////////////////////////////////////////////////////////////////////////////
// Географические зоны (обновление информационной базы)
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - См. процедуру ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Монопольно";
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.8.39";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ItobГеографическиеЗоныОбновлениеИБ.ПеремещениеРеквизитовГеографическихЗонВРегистрыСведений";	

КонецПроцедуры
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПеремещениеРеквизитовГеографическихЗонВРегистрыСведений() Экспорт // "1.1.8.39"
	// Если используется типовой справочник "Географические зоны".
	Если "ItobГеографическиеЗоны" = ItobВызовСервераПовтИсп.ПолучитьИмяОбъекта("ГеографическиеЗоны") Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ItobГеографическиеЗоныУдалитьТочки.Ссылка КАК Ссылка,
		                      |	ItobГеографическиеЗоныУдалитьТочки.НомерСтроки,
		                      |	ItobГеографическиеЗоныУдалитьТочки.Широта,
		                      |	ItobГеографическиеЗоныУдалитьТочки.Долгота,
		                      |	ItobГеографическиеЗоныУдалитьТочки.Ссылка.УдалитьИспользоватьПриГеокодировании КАК ИспользоватьПриГеокодировании
		                      |ИЗ
		                      |	Справочник.ItobГеографическиеЗоны.УдалитьТочки КАК ItobГеографическиеЗоныУдалитьТочки
		                      |ИТОГИ ПО
		                      |	Ссылка");
		ВыборкаГеографическаяЗона = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаГеографическаяЗона.Следующий() Цикл
			Запись = РегистрыСведений.ItobПараметрыГеографическихЗон.СоздатьМенеджерЗаписи();
			Запись.ГеографическаяЗона 			 = ВыборкаГеографическаяЗона.Ссылка;
			Запись.ИспользоватьПриГеокодировании = ВыборкаГеографическаяЗона.ИспользоватьПриГеокодировании;
			Запись.Записать();
			Выборка = ВыборкаГеографическаяЗона.Выбрать();
			Пока Выборка.Следующий() Цикл
				Запись = РегистрыСведений.ItobТочкиГеографическихЗон.СоздатьМенеджерЗаписи();
				Запись.ГеографическаяЗона = Выборка.Ссылка;
			    Запись.НомерТочки = Выборка.НомерСтроки;
				Запись.Широта = Выборка.Широта;
				Запись.Долгота = Выборка.Долгота;
				Запись.Записать();
			КонецЦикла; 
		КонецЦикла;
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти


 