#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = "" + ВидЭлемента + ": " + НаименованиеДляПечати + ", ";
	Для Каждого ДополнительныйРеквизит из РеквизитыВидаЭлемента Цикл
		Если Не ЗначениеЗаполнено(ДополнительныйРеквизит.Значение) Тогда
			Продолжить;
		КонецЕсли;
		Наименование = Наименование + ДополнительныйРеквизит.Значение + ", ";
	КонецЦикла;
	
	Наименование = Лев(Наименование, СтрДлина(Наименование) - 2);
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.ВидыБюджетов") Тогда
		УстановитьНастройкиВидаБюджета();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьНастройкиВидаБюджета()
	Перем Компоновщик;
	
	ИспользоватьДляВводаПлана = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ИспользоватьДляВводаПлана");
	ВидРодителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "ВидЭлемента");
	
	Если ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.ВсеПоказателиБюджетов
		ИЛИ ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.ВсеСтатьиБюджетов
		ИЛИ ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов
		ИЛИ ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.ПоказательБюджетов Тогда
		
		// Если элемент подчинен производному показателю или статье бюджетов - то
		// это операнд формулы
		СброситьИспользованиеФильтров = Ложь;
		
		Если ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов Тогда
			Если НЕ ВидРодителя = Перечисления.ВидыЭлементовФинансовогоОтчета.ПроизводныйПоказатель
				И НЕ ВидРодителя = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов Тогда
				
				СброситьИспользованиеФильтров = ИспользоватьДляВводаПлана;
				
			КонецЕсли;
		КонецЕсли;
		
		Если СброситьИспользованиеФильтров Тогда
			ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоОрганизации", Ложь);
			ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоПодразделению", Ложь);
			ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоСценарию", Ложь);
		КонецЕсли;
		
		Реквизиты = ФинансоваяОтчетностьКлиентСервер.СтруктураЭлементаОтчета();
		ЗаполнитьЗначенияСвойств(Реквизиты, ЭтотОбъект);
		Реквизиты.Вставить("СтатьяБюджетов", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "СтатьяБюджетов"));
		Реквизиты.Вставить("ПоказательБюджетов", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "ПоказательБюджетов"));
		Реквизиты.Вставить("ИспользоватьФильтрПоОрганизации", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоОрганизации") = Истина);
		Реквизиты.Вставить("ИспользоватьФильтрПоПодразделению", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоПодразделению") = Истина);
		Реквизиты.Вставить("ИспользоватьФильтрПоСценарию", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоСценарию") = Истина);
		Реквизиты.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор());
			
		Справочники.ЭлементыФинансовыхОтчетов.УстановитьНастройкиОтбора(Реквизиты, Компоновщик, ВидЭлемента, ДополнительныйОтбор);
		
		СписокЭлементов = Новый Массив;
		Если СброситьИспользованиеФильтров Тогда
			Компоновщик.Настройки.Отбор.Элементы.Очистить();
		КонецЕсли;
		
		Если НЕ Реквизиты.ИспользоватьФильтрПоОрганизации Тогда
			БюджетнаяОтчетностьСервер.НайтиОтборПоИмени(Компоновщик.Настройки, "Организация", СписокЭлементов);
			ФинансоваяОтчетностьСервер.УстановитьОтбор(Компоновщик.Настройки.Отбор, "Организация", 
				"<заполнить_организация>", ВидСравненияКомпоновкиДанных.Равно);
		КонецЕсли;
		
		Если НЕ Реквизиты.ИспользоватьФильтрПоПодразделению Тогда
			БюджетнаяОтчетностьСервер.НайтиОтборПоИмени(Компоновщик.Настройки, "Подразделение", СписокЭлементов);
			ФинансоваяОтчетностьСервер.УстановитьОтбор(Компоновщик.Настройки.Отбор, "Подразделение", 
				"<заполнить_подразделение>", ВидСравненияКомпоновкиДанных.Равно);
		КонецЕсли;
		
		Если НЕ Реквизиты.ИспользоватьФильтрПоСценарию Тогда
			БюджетнаяОтчетностьСервер.НайтиОтборПоИмени(Компоновщик.Настройки, "Сценарий", СписокЭлементов);
			ФинансоваяОтчетностьСервер.УстановитьОтбор(Компоновщик.Настройки.Отбор, "Сценарий", 
				"<заполнить_сценарий>", ВидСравненияКомпоновкиДанных.Равно);
		КонецЕсли;
		
		БюджетнаяОтчетностьСервер.НайтиОтборПоИмени(Компоновщик.Настройки, "", СписокЭлементов);
		
		Для Каждого ЭлементКУдалению из СписокЭлементов Цикл
			Компоновщик.Настройки.Отбор.Элементы.Удалить(ЭлементКУдалению);
		КонецЦикла;
		
		ДополнительныйОтбор = Новый ХранилищеЗначения(Компоновщик.Настройки);
		
	КонецЕсли;
	
	Если ИспользоватьДляВводаПлана Тогда
		
		Если ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов Тогда
			// Если элемент подчинен производному показателю или статье бюджетов - то
			// это операнд формулы
			Если НЕ ВидРодителя = Перечисления.ВидыЭлементовФинансовогоОтчета.ПроизводныйПоказатель
				И НЕ ВидРодителя = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов Тогда
				
				ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "НижняяГраницаДанных", "[Начало периода данных]");
				ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "ВерхняяГраницаДанных", "[Конец периода данных]");
				ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "НачалоПериодаГруппировки", "[Период группировки]");
				ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "КонецПериодаГруппировки", "[Период группировки]");
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли