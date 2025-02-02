
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ВладелецФормы = Неопределено 
		И ВключенВЧат(Объект.Ссылка) Тогда
		Отказ = Истина;
		ОткрытьФорму("Обработка.уатСообщенияМобильногоПриложения.Форма.Форма");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ГруппыДиспетчеров_Запись", Объект.Ссылка, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ВключенВЧат(Ссылка)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ГруппаДиспетчеров", Ссылка);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	               |	уатЧаты.ГруппаДиспетчеров КАК ГруппаДиспетчеров,
	               |	уатЧаты.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.уатЧаты КАК уатЧаты
	               |ГДЕ
	               |	уатЧаты.ГруппаДиспетчеров = &ГруппаДиспетчеров
	               |	И НЕ уатЧаты.ПометкаУдаления";
	РезультатЗапроса = Запрос.Выполнить();
	Возврат НЕ РезультатЗапроса.Пустой();

КонецФункции


#КонецОбласти
