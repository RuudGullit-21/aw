#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет заполнение предопределенных элементов справочника
//
Процедура ЗаполнитьПредопределенныеДанные() Экспорт
	
	СпрОбъект = Справочники.уатСтатусыТопливныхКарт.Действует.ПолучитьОбъект();
	СпрОбъект.Действует = Истина;
	СпрОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли