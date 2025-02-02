////////////////////////////////////////////////////////////////////////////////
// Управление автотранспортом.
// 
// Работа с расширениями конфигурации.
// 
// Содержит код, используемый в варианте поставке ПРОФ, КОРП
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

///////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С РАСШИРЕНИЕМ КОНФИГУРАЦИИ (ПОДКЛЮЧАЕМАЯ СИСТЕМА МОНИТОРИНГА)
//
#Область ПроцедурыИФункцииДляРаботыПСМ

Процедура ПСМ_ВыполнитьДействияВФорме(ИдентификаторДействия, СистемаМониторинга, УчетнаяЗапись = Неопределено, ЭтотОбъект = Неопределено, ДопПараметры = Неопределено) Экспорт
	
	Заглушка = Истина;
	
КонецПроцедуры

#КонецОбласти

///////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С РАСШИРЕНИЕМ КОНФИГУРАЦИИ (ПОДКЛЮЧАЕМАЯ СИСТЕМА ПРОЦЕССИНГОВОГО ЦЕНТРА)
//
#Область ПроцедурыИФункцииДляРаботыПСПЦ

Процедура ПСПЦ_ВыполнитьДействияВФорме(ИдентификаторДействия, СистемаМониторинга, УчетнаяЗапись = Неопределено, ЭтотОбъект = Неопределено, ДопПараметры = Неопределено) Экспорт
	
	Заглушка = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти