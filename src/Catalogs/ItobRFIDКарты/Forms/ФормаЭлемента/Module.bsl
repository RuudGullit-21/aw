
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Объект.Номер;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
