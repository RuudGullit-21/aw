
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если (НЕ ЭтоГруппа) И ПрейскурантПоставщика Тогда
		ПроверяемыеРеквизиты.Добавить("Контрагент");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти