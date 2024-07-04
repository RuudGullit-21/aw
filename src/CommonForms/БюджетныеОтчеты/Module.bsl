
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МодельБюджетирования = Справочники.МоделиБюджетирования.МодельБюджетированияПоУмолчанию();
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокВидовБюджетов, "Владелец", МодельБюджетирования, ЗначениеЗаполнено(МодельБюджетирования));
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокВидовБюджетов, "Владелец", МодельБюджетирования, ЗначениеЗаполнено(МодельБюджетирования));
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МодельБюджетированияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокВидовБюджетов, "Владелец", МодельБюджетирования, ЗначениеЗаполнено(МодельБюджетирования));
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВидовБюджетов

&НаКлиенте
Процедура СписокВидовБюджетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
		СформироватьОтчет(Элемент.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	ТекущаяСтрока = Элементы.СписокВидовБюджетов.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущаяСтрока.ЭтоГруппа Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Report generation by group is not available.';ru='Формирование отчета по группе не доступно.'"));
		Возврат;
	КонецЕсли;
	
	СформироватьОтчет(ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьОтчет(ТекущаяСтрока)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ВидБюджета",           ТекущаяСтрока.ВидБюджета);
	ПараметрыОтчета.Вставить("МодельБюджетирования", ТекущаяСтрока.Владелец);
	ПараметрыОтчета.Вставить("СформироватьБюджетныйОтчетПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.БюджетныйОтчет.Форма.ФормаОтчета", ПараметрыОтчета, ЭтотОбъект, Истина);
	
КонецПроцедуры

#КонецОбласти

