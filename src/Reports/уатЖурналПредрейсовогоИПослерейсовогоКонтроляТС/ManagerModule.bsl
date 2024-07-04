#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатОтчетОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки – Коллекция – Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//   НастройкиОтчета – СтрокаДереваЗначений – Настройки размещения всех вариантов отчета.
//       См. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "");
	
	НастройкиВарианта.Описание = 
		НСтр("en='Report shows Vehicle pre-trip and post-trip control journal records.'"
			+";ru='Отчет отображает записи Журнала предрейсового и послерейсового контроля ТС.'");
	
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
		НСтр("en='Log';ru='Журнал'");
	
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
		НСтр("en='Period';ru='Период'");
	
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова = ""
		+ НСтр("en='journal';ru='журнал'") + Символы.ПС
		+ НСтр("en='pre-trip';ru='предрейсовый'") + Символы.ПС
		+ НСтр("en='post-trip';ru='послерейсовый'") + Символы.ПС
		+ НСтр("en='control';ru='контроль'") + Символы.ПС;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли