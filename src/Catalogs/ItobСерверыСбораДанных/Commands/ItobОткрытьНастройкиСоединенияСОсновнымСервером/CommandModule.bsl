
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Справочник.ItobСерверыСбораДанных.Форма.ФормаЭлемента", 
				 Новый Структура("Ключ", ПредопределенноеЗначение("Справочник.ItobСерверыСбораДанных.Основной")), 
				 ПараметрыВыполненияКоманды.Источник, 
				 ПараметрыВыполненияКоманды.Уникальность, 
				 ПараметрыВыполненияКоманды.Окно,
				 ПараметрыВыполненияКоманды.НавигационнаяСсылка);
				 
КонецПроцедуры

#КонецОбласти
