#Область СлужебныйПрограммныйИнтерфейс

// Выполняет необходимые действия при изменении реквизита Организация
//
Процедура ПриИзмененииОрганизации(ПодменюДействияФормы = Неопределено, ЭлементыФормыНомер = Неопределено) Экспорт
	
	Если Не ПустаяСтрока(Номер) Тогда
		уатОбщегоНазначенияТиповые.уатСброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, "Номер", ПодменюДействияФормы,
																			ЭлементыФормыНомер);
	КонецЕсли;
	
КонецПроцедуры // ПриИзмененииОрганизации()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	уатОбщегоНазначения.ПроверкаЗаполненияПодразделения(Организация, Подразделение, Отказ, Заголовок);
КонецПроцедуры

#КонецОбласти
