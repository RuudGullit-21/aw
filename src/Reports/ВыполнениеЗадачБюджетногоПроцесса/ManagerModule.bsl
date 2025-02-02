#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВариантыОтчетов

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
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ВсеЗадачи");
	НастройкиВарианта.Описание = НСтр("en='Выполнены или нет задачи бюджетирования?"
"Какие просрочены, кем и на сколько дней?';ru='Выполнены или нет задачи бюджетирования?"
"Какие просрочены, кем и на сколько дней?'");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СтатистикаПоИсполнениюЗадач");
	НастройкиВарианта.Описание = НСтр("en='Сколько бюджетных задач выполнено и не выполнено исполнителями?"
"В рамках каких бюджетных шагов?';ru='Сколько бюджетных задач выполнено и не выполнено исполнителями?"
"В рамках каких бюджетных шагов?'");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТекущиеЗадачи");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СвязанныеЗадачи");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТекущиеЗадачиРасшифровка");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	
КонецПроцедуры // НастроитьВариантыОтчета

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецЕсли