
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ТекстОшибки = "";
	уатИнтеграции_уэ.АТИ_ЗагрузкаДанныхВТендер(, ТекстОшибки);
	
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстСообщения = НСтр("ru='Загрузка данных выполнена успешно.'");
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
	Иначе
		ПоказатьПредупреждение(Неопределено, ТекстОшибки);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
