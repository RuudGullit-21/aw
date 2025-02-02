#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет заполнение предопределенных элементов справочника.
//
Процедура ЗаполнитьПредопределенныеДанные() Экспорт
	
	// Обновление предопределенного элемента "ЗакрытУспешно".
	СправочникОбъект = Справочники.уатПричиныЗакрытияЗаказов.ЗакрытУспешно.ПолучитьОбъект();
	СправочникОбъект.ИспользоватьВМобильномПриложении = Истина;
	СправочникОбъект.ЗакрытУспешно = Истина;
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
	
	// Обновление предопределенного элемента "Отклонен".
	СправочникОбъект = Справочники.уатПричиныЗакрытияЗаказов.Отклонен.ПолучитьОбъект();
	СправочникОбъект.ИспользоватьВМобильномПриложении = Истина;
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли