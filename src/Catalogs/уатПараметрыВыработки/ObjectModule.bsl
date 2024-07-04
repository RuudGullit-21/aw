#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Только складская обработка не рассчитывается в документах ТТД.
	Если НЕ ИспользоватьВТарифахНаУслуги
		И ИмяПредопределенныхДанных <> "СкладскаяОбработка"
		И ИмяПредопределенныхДанных <> "ПревышениеВеса"
		И ИмяПредопределенныхДанных <> "ПревышениеОбъема"
		И ИмяПредопределенныхДанных <> "ПревышениеВысоты"
		И ИмяПредопределенныхДанных <> "ПревышениеДлины"
		И ИмяПредопределенныхДанных <> "ПревышениеШирины"
		И ИмяПредопределенныхДанных <> "НочнаяДоставка"
		И ИмяПредопределенныхДанных <> "Наценка"
		И НЕ СводныйПоказатель Тогда
		ИспользоватьВТарифахНаУслуги = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ИспользоватьДляМаршрутныхЛистов Тогда
		ПроверяемыеРеквизиты.Добавить("СпособВводаЗначений");
	КонецЕсли;
	
	Если СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.КоличествоОперацийПоТипуТочкиМаршрута Тогда
		ПроверяемыеРеквизиты.Добавить("ТипТочкиМаршрута");
	КонецЕсли;
	Если СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.КоличествоТочекПоТипуПункта Тогда
		ПроверяемыеРеквизиты.Добавить("ТипПункта");
	КонецЕсли;
	Если СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.КоличествоУпаковокПоВидуУпаковки Тогда
		ПроверяемыеРеквизиты.Добавить("ВидУпаковки");
	КонецЕсли;
	Если СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.КоличествоКонтейнеровПоТипуКонтейнера Тогда
		ПроверяемыеРеквизиты.Добавить("ТипКонтейнера");
	КонецЕсли;
	Если СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.ПоПараметруВыработки Тогда
		ПроверяемыеРеквизиты.Добавить("БазовыйПараметрВыработки");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СпособРасчетаПараметровВыработки)
		И (СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.ПоШапке
		ИЛИ СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.ПоЗаданию
		ИЛИ СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.ПоТТД
		ИЛИ СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.ПоЗаказамИМаршрутнымЛистам) Тогда
		ПроверяемыеРеквизиты.Добавить("АлгоритмРасчетаПараметра");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти