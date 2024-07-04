
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ПериодАвтоматическогоОбновления", ПериодАвтоматическогоОбновления);
	Параметры.Свойство("КластеризацияМаркеровНаКарте",    КластеризацияМаркеровНаКарте);
	Параметры.Свойство("ПунктФокусировкиПриОткрытии",     ПунктФокусировкиПриОткрытии);
	Параметры.Свойство("НачальныйМасштаб",                НачальныйМасштаб);
	Параметры.Свойство("ИспользоватьАвтомасштабирование", ИспользоватьАвтомасштабирование);
	Параметры.Свойство("МаксимальныйРадиусКластера",      МаксимальныйРадиусКластера);
	Параметры.Свойство("КаталогПунктовНаКарте",           КаталогПунктовНаКарте);
	
	ОпределитьДопустимоеОтклонениеОтВремени();
	ЗаполнитьСписокВыбораМасштаба();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Результат = Новый Структура();
	Результат.Вставить("ПериодАвтоматическогоОбновления", ПериодАвтоматическогоОбновления);
	Результат.Вставить("КластеризацияМаркеровНаКарте",    КластеризацияМаркеровНаКарте);
	Результат.Вставить("ПунктФокусировкиПриОткрытии",     ПунктФокусировкиПриОткрытии);
	Результат.Вставить("НачальныйМасштаб",                НачальныйМасштаб);
	Результат.Вставить("ИспользоватьАвтомасштабирование", ИспользоватьАвтомасштабирование);
	Результат.Вставить("МаксимальныйРадиусКластера",      МаксимальныйРадиусКластера);
	Результат.Вставить("КаталогПунктовНаКарте",           КаталогПунктовНаКарте); 

	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура КластеризацияМаркеровНаКартеПриИзменении(Элемент)
	Элементы.МаксимальныйРадиусКластера.Видимость = КластеризацияМаркеровНаКарте;
КонецПроцедуры

&НаКлиенте
Процедура НастроитьШаблонИнформацииПоГрузу(Команда)
	ОткрытьФорму("Обработка.уатЭлектронныеКарты.Форма.ФормаНастроекШаблонаИнформацииПоГрузу",, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьДопустимоеОтклонениеОтВремени()
	
	ТекПользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
	ОсновнаяОрганизация              = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ТекПользователь, "ОсновнаяОрганизация");
	ОсновноеПодразделениеОрганизации = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ТекПользователь, "ОсновноеПодразделениеОрганизации");
	
	СтруктураОбъектовНастроек = Новый Структура;
	СтруктураОбъектовНастроек.Вставить("Организация",   ОсновнаяОрганизация);
	СтруктураОбъектовНастроек.Вставить("Подразделение", ОсновноеПодразделениеОрганизации);
	
	ДопустимоеОтклонениеОтВремениПрибытия = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(СтруктураОбъектовНастроек, ПланыВидовХарактеристик.уатПраваИНастройки.ДопустимоеОтклонениеОтВремениПрибытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораМасштаба()
	
	Для Сч = 1 По 18 Цикл 
		Элементы.НачальныйМасштаб.СписокВыбора.Добавить(Сч);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
