#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатУстановкаТарифовЗП.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение_проф.ОтразитьТарифыЗП(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатУстановкаТарифовЗП.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		// Заголовок для сообщений об ошибках проведения.
		Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
		
		СтруктураПолей = Новый Структура("Организация, Ответственный");
		уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураПолей, Отказ, Заголовок);
		СтруктураПолей = Новый Структура("Тариф, Сотрудник, ДатаНачала");
		уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Тарифы", СтруктураПолей, Отказ, Заголовок);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// уатСогласованиеДокументов
	уатСогласованиеДокументовСервер.ПередЗаписью(ЭтотОбъект, РежимЗаписи, Отказ);
	// Конец уатСогласованиеДокументов
КонецПроцедуры

#КонецОбласти
