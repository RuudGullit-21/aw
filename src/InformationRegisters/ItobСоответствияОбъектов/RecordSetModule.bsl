#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Обязательная конструкция "Если ОбменДанными.Загрузка Тогда ...".
	Если ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли; 
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли