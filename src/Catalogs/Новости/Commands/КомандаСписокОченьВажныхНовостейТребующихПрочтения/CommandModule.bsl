///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Работает только если подсистема ИПП выключена из командного интерфейса.
// e1cib/command/Справочник.Новости.Команда.КомандаСписокОченьВажныхНовостейТребующихПрочтения.

// Важно, что подсистема ИнтернетПоддержкаПользователей должна быть включена в командный интерфейс (хотя может быть и не видна).
// Иначе будет ошибка при вызове этой команды.
// При изменении наименования подсистемы ИнтернетПоддержкаПользователей, необходимо изменить ссылки и здесь.
// НЕ работает, если подсистема ИПП выключена из командного интерфейса.
// e1cib/navigationpoint/ИнтернетПоддержкаПользователей/Справочник.Новости.Команда.КомандаСписокОченьВажныхНовостейТребующихПрочтения.

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	// Вначале найти окно со списком новостей.
	ОкноЧтенияНовостейОткрыто = Ложь;
	СписокОткрытыхОкон = ПолучитьОкна();
	Для каждого ОткрытоеОкно Из СписокОткрытыхОкон Цикл
		// Если окно открыто на рабочем столе, то нельзя понять, открыто оно или нет
		Если (НЕ ОткрытоеОкно.Основное) И (ОткрытоеОкно.Заголовок = НСтр("ru = 'Новости 1С'; en = '1C news'")) Тогда
			ОкноЧтенияНовостейОткрыто = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	// Если окно чтения новостей не открыто, открыть его.
	Если ОкноЧтенияНовостейОткрыто = Ложь Тогда
		Если ПараметрыВыполненияКоманды = Неопределено Тогда

			ПараметрыОткрытияФормы = Новый Структура;

			ИмяФормы = "Справочник.Новости.Форма.ФормаПросмотраНовостей"; // ИмяФормы
			ОбработкаНовостейКлиентПереопределяемый.ПереопределитьПараметрыОткрытияФормыСпискаНовостей(
				ИмяФормы,
				ПараметрыОткрытияФормы,
				ПараметрКоманды,
				ПараметрыВыполненияКоманды);

			ОткрытьФорму(
				ИмяФормы,
				ПараметрыОткрытияФормы,
				Неопределено,
				""); // Уникальность

		Иначе

			ПараметрыОткрытияФормы = Новый Структура;

			ИмяФормы = "Справочник.Новости.Форма.ФормаПросмотраНовостей"; // ИмяФормы
			ОбработкаНовостейКлиентПереопределяемый.ПереопределитьПараметрыОткрытияФормыСпискаНовостей(
				ИмяФормы,
				ПараметрыОткрытияФормы,
				ПараметрКоманды,
				ПараметрыВыполненияКоманды);

			ОткрытьФорму(
				ИмяФормы,
				ПараметрыОткрытияФормы,
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Уникальность);

		КонецЕсли;
	КонецЕсли;

	// Оповестить о фильтрации.
	// Сейчас Важные и Очень важные новости отображаются одинаково.
	Оповестить(
		"Новости. Активизировать папку отбора", // Событие
		Новый Структура("ВариантОтбора", 5), // ЗначениеОтбора не нужно.
		Неопределено);

КонецПроцедуры

#КонецОбласти
