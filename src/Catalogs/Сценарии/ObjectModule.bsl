#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Ссылка = Справочники.Сценарии.ФактическиеДанные Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Периодичность");
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	Если Не ИспользоватьКурсыДругогоСценария Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СценарийКурсов");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли