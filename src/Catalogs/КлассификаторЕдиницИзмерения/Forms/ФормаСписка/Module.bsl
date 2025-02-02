
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.КлассификаторЕдиницИзмерения) Тогда 
		Элементы.ФормаПодобратьИзМакета.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзМакета(Команда)
	
	СтрокаПоиска = "";
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		СтрокаПоиска = ТекДанные.Код;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("СтрокаПоиска", СтрокаПоиска);
	ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.ФормаВыбораИзКлассификатора",
		СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
