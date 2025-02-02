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
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Штрафы");
	НастройкиВарианта.Описание = НСтр("en='Report provides detailed information about fines.';ru='Отчет позволяет получить детальную информацию о штрафах.'");
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РейтингВодителей");
	НастройкиВарианта.Описание = НСтр("en='Report allows you to show the driver rating by the number of fines.';ru='Отчет позволяет отобразить рейтинг водителей по количеству штрафов.'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОтчетПоШтрафам1");
	НастройкиВарианта.Описание = НСтр("en='report provides information on fines grouped by periods.';ru='Отчет позволяет получить информацию о штрафах с группировкой по периодам.'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОтчетПоШтрафам2");
	НастройкиВарианта.Описание = НСтр("en='Report provides information on fines grouped by department and nature of violations.';ru='Отчет позволяет получить информацию о штрафах с группировкой по подразделению и характеру нарушений.'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "НеПодписанныеСогласия");
	НастройкиВарианта.Описание = НСтр("en='Report provides information on fines with unsigned consent from the driver.';ru='Отчет позволяет получить информацию о штрафах с неподписанным согласием водителя.'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КоличествоИОплатаВМесяц");
	НастройкиВарианта.Описание = НСтр("en='Report provides the number and amount of fines with grouping by months.';ru='Отчет позволяет получить количество и сумму штрафов с группировкой по месяцам.'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КоличествоИОплатаВМесяцГрафик");
	НастройкиВарианта.Описание = НСтр("en='Report provides the number and amount of fines with grouping by month in chart.';ru='Отчет позволяет получить количество и сумму штрафов с группировкой по месяцам в виде диаграммы.'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОтчетПоХарактеруНарушений");
	НастройкиВарианта.Описание = НСтр("en='Report provides information on fines grouped by character of violations.';ru='Отчет позволяет получить информацию о штрафах с группировкой по характеру нарушений.'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ЧислящиесяШтрафы");
	НастройкиВарианта.Описание = НСтр("en='Report provides the number and amount of fines with grouping by department.';ru='Отчет позволяет получить количество и сумму штрафов с группировкой по подразделению.'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли