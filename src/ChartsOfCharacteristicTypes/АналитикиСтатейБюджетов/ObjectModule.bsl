#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если УчитыватьПоВалюте Тогда
		ПроверяемыеРеквизиты.Добавить("ЗаполнениеВалюты");
	КонецЕсли;
	
	Если УчитыватьПоКоличеству Тогда
		ПроверяемыеРеквизиты.Добавить("ЗаполнениеЕдиницыИзмерения");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
