#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда 
		Наименование = уатНастройкиШаблонов.СформироватьНаименованиеПоШаблону("Справочник_уатСерииНоменклатуры", ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли