
#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	#Если Клиент Тогда
		Оповестить("Изменен регистр агрегаты ТС");
	#КонецЕсли
КонецПроцедуры

#КонецОбласти