#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	
#Область ПрограммныйИнтерфейс

// Задает настройки размещения вариантов отчетов в панели отчетов.
// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       См. ""Реквизиты для изменения"" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Анализ отгрузки");
	НастройкиВарианта.Описание = НСтр("en='Report is intended to analyze the planned and factual departure of сargo from temporary storage area.';ru='Отчет предназначен для план-фактного анализа отправления грузов со складов комплектации.'");
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатОтчетОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли