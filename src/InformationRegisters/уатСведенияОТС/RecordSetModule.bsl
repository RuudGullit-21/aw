#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Количество() = 1 Тогда
		ТекИндекс = ПроверяемыеРеквизиты.Найти("НалоговаяЛьгота");
		Если ТекИндекс <> Неопределено И НЕ ЭтотОбъект[0].НачислятьТранспортныйНалог Тогда
			ПроверяемыеРеквизиты.Удалить(ТекИндекс);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
