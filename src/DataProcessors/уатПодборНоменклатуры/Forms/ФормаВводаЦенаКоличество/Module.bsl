#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокСвойств = "Валюта, Цена, Количество, Номенклатура";
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, СписокСвойств);
	
	Если Не Параметры.ЕстьЦена Тогда
		Элементы.ГруппаЦена.Видимость  = Ложь;
		Элементы.ГруппаСумма.Видимость = Ложь;

		ЭтотОбъект.Заголовок      = НСтр("en='Enter quantity';ru='Ввод количества'");
	КонецЕсли;
	
	Если Не Параметры.ЕстьКоличество Тогда
		Элементы.ГруппаКоличество.Доступность = Ложь;
		
		ЭтотОбъект.Заголовок = НСтр("en='Input prices';ru='Ввод цены'");
	КонецЕсли;
	
	Сумма = Цена * Количество;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	Сумма = Цена * Количество;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	Сумма = Цена * Количество;

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	Если Количество = 0 Тогда
		ОчиститьСообщения();
		ТекстНСТР = НСтр("en='Not filled number';ru='Не заполнено количество'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР,, "Количество",, Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрЗакрытия = Новый Структура;
	ПараметрЗакрытия.Вставить("Цена"      , Цена);
	ПараметрЗакрытия.Вставить("Количество", Количество);
	
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти
