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
		НСтр("en='Report provides information about driver work by waybills.';ru='Отчет позволяет получить информацию о работе водителя по путевым листам.'");
	
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
		НСтр("en='Card';ru='Карточка'");
	
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов = ""
		+ НСтр("en='Period';ru='Период'") + Символы.ПС
		+ НСтр("en='Driver';ru='Водитель'");
	
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова = ""
		+ НСтр("en='accounting';ru='учет'") + Символы.ПС
		+ НСтр("en='driver work';ru='работа водителя'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли