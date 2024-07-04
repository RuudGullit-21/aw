#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ЗначениеГруппировкиТарифа2.Видимость = ЗначениеЗаполнено(Параметры.ГруппировкаТарифа2);
	Элементы.ЗначениеГруппировкиТарифа3.Видимость = ЗначениеЗаполнено(Параметры.ГруппировкаТарифа3);
	Элементы.ЗначениеГруппировкиТарифа4.Видимость = ЗначениеЗаполнено(Параметры.ГруппировкаТарифа4);
	Элементы.ЗначениеГруппировкиТарифа1.Заголовок = "" + Параметры.ГруппировкаТарифа1 + " <= ";
	Элементы.ЗначениеГруппировкиТарифа2.Заголовок = "" + Параметры.ГруппировкаТарифа2 + " <= ";
	Элементы.ЗначениеГруппировкиТарифа3.Заголовок = "" + Параметры.ГруппировкаТарифа3 + " <= ";
	Элементы.ЗначениеГруппировкиТарифа4.Заголовок = "" + Параметры.ГруппировкаТарифа4 + " <= ";
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ПараметрыЗакрытия = Новый Структура("ЗначениеГруппировки1, ЗначениеГруппировки2, ЗначениеГруппировки3, ЗначениеГруппировки4",
		ЗначениеГруппировкиТарифа1, ЗначениеГруппировкиТарифа2, ЗначениеГруппировкиТарифа3, ЗначениеГруппировкиТарифа4);
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры

#КонецОбласти
